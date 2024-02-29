`include "lscc_defines.svh"

// Instantiate driver based on board
module led_driver_top #( BOARD   = "XO5_EVAL" )
(
  input              clk_i,
  input              rstn_i,
  output logic [7:0] seg_display_o,
  output logic [7:0] led_display_o,
  output logic [2:0] seg_sel_o   
);

  logic       rst_n;  //System Reset
  
// Synchronise reset to system clk
  sync_rstn #(2)
    sync_rstn_inst (
      .clk_i(clk_i),
      .rstn_i(rstn_i),
      .rstn_o(rst_n)
    );

// LED Driver (Parameters set to match target board) 
  generate 

    case (BOARD)
      // Avant G & X Versa Boards
      "ATG_VERSA": begin
        svn_seg_cntr # (
          .CLK_IN_MHZ(100),
          .LED_POLARITY(1'b1)
        ) svn_seg_inst (
          .clk_i(clk_i), 
          .rstn_i(rst_n), 
          .display_o(seg_display_o),
          .seg_sel_o(seg_sel_o)
        );
      end

      // Avant E Eval Board
      "ATE_EVAL": begin
        svn_seg_cntr # (
          .CLK_IN_MHZ(12),
          .LED_POLARITY(1'b1)
        ) svn_seg_inst (
          .clk_i(clk_i), 
          .rstn_i(rst_n), 
          .display_o(seg_display_o),
          .seg_sel_o(seg_sel_o)
        );

        led_kitt # (
          .CLK_IN_MHZ(12),
          .LED_POLARITY(1'b1)
        ) led_kitt_inst (
          .clk_i(clk_i), 
          .rstn_i(rst_n), 
          .display_o(led_display_o)
        );
      end
 
      // MachXO5NX Eval Board
      "XO5_EVAL": begin
        led_kitt # (
          .CLK_IN_MHZ(125),
          .LED_POLARITY(1'b1)
        ) led_kitt_inst (
          .clk_i(clk_i), 
          .rstn_i(rst_n), 
          .display_o(led_display_o)
        );

        svn_seg_cntr # (
          .CLK_IN_MHZ(125),
          .LED_POLARITY(1'b0)
        ) svn_seg_inst (
          .clk_i(clk_i), 
          .rstn_i(rst_n), 
          .display_o(seg_display_o),
          .seg_sel_o()
        );
      end

    endcase // BOARD
 
  endgenerate

endmodule
