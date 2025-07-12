module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

// Multiplexer to select between input data and current shift register value
wire [63:0] mux_out = (load)? data : q_reg;

// Barrel shifter to perform left and right shifts
wire [63:0] shift_out;
assign shift_out = (amount == 2'b00)? {mux_out[62:0], 1'b0} :  // Left shift by 1 bit
                  (amount == 2'b01)? {mux_out[55:0], 8'b0} :  // Left shift by 8 bits
                  (amount == 2'b10)? {mux_out[63], mux_out[63:1]} :  // Arithmetic right shift by 1 bit
                  (amount == 2'b11)? {mux_out[63], mux_out[63], mux_out[63], mux_out[63], mux_out[63], mux_out[63], mux_out[63], mux_out[63], mux_out[63:8]} :  // Arithmetic right shift by 8 bits
                  mux_out;

// Control unit to manage loading, enabling, and shift direction
wire [63:0] next_q = (ena)? shift_out : q_reg;

always @(posedge clk) begin
  q_reg <= next_q;
end

assign q = q_reg;

endmodule