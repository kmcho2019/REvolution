module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

// Define the 8-bit shift register module
module shift_reg_8bit (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [7:0] data,
  output [7:0] q
);

reg [7:0] q_reg;

always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else if (ena) begin
    case (amount)
      2'b00: q_reg <= {q_reg[6:0], 1'b0}; // shift left by 1 bit
      2'b01: q_reg <= {q_reg[0:0], 7'b0}; // shift left by 8 bits (wrap around)
      2'b10: q_reg <= {q_reg[7], q_reg[7:1]}; // shift right by 1 bit (arithmetic)
      2'b11: q_reg <= { {7{q_reg[7]}}, q_reg[7:7]}; // shift right by 8 bits (arithmetic)
      default: q_reg <= q_reg;
    endcase
  end
end

assign q = q_reg;

endmodule

// Instantiate eight 8-bit shift registers
wire [7:0] q0, q1, q2, q3, q4, q5, q6, q7;
shift_reg_8bit u0 (.clk(clk), .load(load), .ena(ena), .amount(amount), .data(data[7:0]), .q(q0));
shift_reg_8bit u1 (.clk(clk), .load(load), .ena(ena), .amount(amount), .data(data[15:8]), .q(q1));
shift_reg_8bit u2 (.clk(clk), .load(load), .ena(ena), .amount(amount), .data(data[23:16]), .q(q2));
shift_reg_8bit u3 (.clk(clk), .load(load), .ena(ena), .amount(amount), .data(data[31:24]), .q(q3));
shift_reg_8bit u4 (.clk(clk), .load(load), .ena(ena), .amount(amount), .data(data[39:32]), .q(q4));
shift_reg_8bit u5 (.clk(clk), .load(load), .ena(ena), .amount(amount), .data(data[47:40]), .q(q5));
shift_reg_8bit u6 (.clk(clk), .load(load), .ena(ena), .amount(amount), .data(data[55:48]), .q(q6));
shift_reg_8bit u7 (.clk(clk), .load(load), .ena(ena), .amount(amount), .data(data[63:56]), .q(q7));

// Combine the outputs of the 8-bit shift registers
assign q = {q7, q6, q5, q4, q3, q2, q1, q0};

endmodule