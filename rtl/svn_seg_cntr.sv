`include "lscc_defines.svh"

module svn_seg_cntr #(
  parameter CLK_IN_MHZ   = 125,
            LED_POLARITY = 1'b0  )
(
  input              clk_i,
  input              rstn_i,
  output logic [7:0] display_o,
  output logic [2:0] seg_sel_o 
);

// Local parameters & Constants

  // 7 Segment display decoder
  localparam [0:15] [7:0] SEG7DISP = {
    8'b10111111, 
    8'b00000110,
    8'b01011011,
    8'b01001111, 
    8'b01100110,
    8'b01101101,
    8'b01111101,
    8'b00000111,
    8'b01111111,
    8'b01101111,
    8'b01110111,
    8'b01111100,
    8'b00111001,
    8'b01011110,
    8'b01111001,
    8'b01110001
  } ;
  
  localparam SYS_FREQ = CLK_IN_MHZ * 1000 * 1000;

// Signal Declarations
  
  logic [$clog2(SYS_FREQ)-1:0] prescaler;
  logic                        prescaler_tc;
  logic                  [3:0] display_counter;

// Module Behaviour

`ifndef SIM

  // Prescaler generates 1Hz pulse to enable display counter
  always_ff @(posedge clk_i, negedge rstn_i) begin : prescale
    if (!rstn_i) prescaler <= 'b0;
    else         prescaler <= prescaler_tc ? 'b0 : prescaler + 1;
  end : prescale

  assign prescaler_tc = (prescaler == SYS_FREQ - 1) ;
  
`else 

  // Disable prescaler for simulation
  assign prescaler = 'b0;
  assign prescaler_tc = 1'b1; 

`endif

  // Display Counter - Increment once per prescaler pulse
  always_ff @(posedge clk_i, negedge rstn_i) begin : dsply_cntr
    if (!rstn_i) display_counter <= 'b0;
    else if (prescaler_tc) display_counter  <= display_counter + 1;
  end : dsply_cntr

  // Display Decoder - binary to 7 seg display
  always_ff @(posedge clk_i, negedge rstn_i) begin : dsply_dcdr
    if (!rstn_i) display_o <= 'b0;
    else         display_o <= LED_POLARITY ? SEG7DISP[display_counter] : ~SEG7DISP[display_counter] ;
  end : dsply_dcdr

  // Enable single digit of 3 x 7seg display
  assign seg_sel_o = 3'b010;

endmodule
