`include "lscc_defines.svh"

module svn_seg_cntr #(
    byte CLK_IN_MHZ   = 125,
    bit  LED_POLARITY = 1'b0
) (
    input              clk_i,
    input              rstn_i,
    output logic [7:0] seg_display_o,
    output logic [2:0] seg_sel_o
);

  // Local parameters & Constants

  // 7 Segment display decoder
  localparam bit [15:0][7:0] SEG7DISP = {
    8'b01110001,
    8'b01111001,
    8'b01011110,
    8'b00111001,
    8'b01111100,
    8'b01110111,
    8'b01101111,
    8'b01111111,
    8'b00000111,
    8'b01111101,
    8'b01101101,
    8'b01100110,
    8'b01001111,
    8'b01011011,
    8'b00000110,
    8'b10111111
  };

  localparam int SysFreq = CLK_IN_MHZ * 1000 * 1000;

  // Signal Declarations

  logic [$clog2(SysFreq)-1:0] prescaler, prescaler_tc;
  logic [                3:0] seg_counter;

  // Module Behaviour

`ifndef SIM

  // Prescaler generates 1Hz pulse to enable display counter
  always_ff @(posedge clk_i, negedge rstn_i) begin : prescale
    if (!rstn_i) prescaler <= 'b0;
    else prescaler <= prescaler_tc ? 'b0 : prescaler + 1;
  end : prescale

  assign prescaler_tc = (prescaler == SysFreq - 1);

`else

  // Disable prescaler for simulation
  assign prescaler = 'b0;
  assign prescaler_tc = 1'b1;

`endif

  // Display Decoder - Increment once per prescaler pulse & decode result
  always_ff @(posedge clk_i) begin : dsply_dcdr
    if (prescaler_tc) begin
      seg_counter   <= seg_counter + 1;
      seg_display_o <= LED_POLARITY ? SEG7DISP[seg_counter] : ~SEG7DISP[seg_counter];
    end
  end : dsply_dcdr

  // Enable ALL digits of 3 x 7seg display
  assign seg_sel_o = 3'b111;

endmodule
