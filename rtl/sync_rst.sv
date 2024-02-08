//
// Sync Active Low Reset to clock
//
// Number of sync stages controlled by STAGES parameter
//
module sync_rst # ( STAGES = 2 )
(
  input        clk_i,
  input        rstn_i,
  output logic rstn_o
);

  logic [STAGES-1:0] shift_reg;  // Reset Synchroniser

  always_ff @(posedge clk_i, negedge rstn_i)
    if (!rstn_i) shift_reg <= 'b0;
    else         shift_reg <= {1'b1, shift_reg[$high(shift_reg):1]};

  assign rstn_o = shift_reg[0];
  
endmodule
