module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

// Define the next state of the shift register
wire [63:0] next_q;

assign next_q = (load)? data :
                 (ena)? (
                   (amount == 2'b00)? {q_reg[62:0], 1'b0} : // shift left by 1 bit
                   (amount == 2'b01)? {q_reg[55:0], 8'b0} : // shift left by 8 bits
                   (amount == 2'b10)? {q_reg[63], q_reg[63:1]} : // shift right by 1 bit (arithmetic)
                   (amount == 2'b11)? { {56{q_reg[63]}}, q_reg[63:8]} : // shift right by 8 bits (arithmetic)
                   q_reg
                 ) :
                 q_reg;

// Update the state of the shift register
always @(posedge clk) begin
  q_reg <= next_q;
end

// Assign the output
assign q = q_reg;

endmodule