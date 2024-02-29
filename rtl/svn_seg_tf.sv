`include "lscc_defines.svh"

`timescale 1 ns / 1 ps

// Define Module for Test Fixture
module svn_seg_tf();

  // Inputs
  reg clk_i=0;
  reg rstn_i=0;

  // Outputs
  wire [7:0] display_o;

  // Bidirs

  // Instantiate the UUT
  // Please check and add your parameters manually
  svn_seg_cntr UUT (
    .clk_i(clk_i), 
    .rstn_i(rstn_i), 
    .display_o(display_o),
	.seg_sel_o() 
  );

  // System clock
  initial begin
  clk_i = '1;
    forever #(5) clk_i = ~clk_i;
  end

  // synchronous reset
  initial begin
    rstn_i <= '1;
    repeat(5)@(negedge clk_i);
    rstn_i <= '0;
    repeat(5)@(negedge clk_i);
    rstn_i <= '1;
  end


  //GSR GSR_INST (.GSR(rstn_i));
  //PUR PUR_INST (.PUR(rstn_i));

endmodule 
