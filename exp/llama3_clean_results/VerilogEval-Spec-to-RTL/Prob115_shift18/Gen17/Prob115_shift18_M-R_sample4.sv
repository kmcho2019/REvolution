module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

// Define the next state based on the current state and inputs
wire [63:0] shift_left_1 = {q_reg[62:0], 1'b0};
wire [63:0] shift_left_8 = {q_reg[55:0], 8'b0};
wire [63:0] shift_right_1 = {q_reg[63], q_reg[63:1]};
wire [63:0] shift_right_8 = { {8{q_reg[63]}}, q_reg[63:8] };

// Use a case statement for clarity in selecting the next state
wire [63:0] next_q;
always @(q_reg, load, ena, amount, data) begin
  case (amount)
    2'b00: next_q = (ena) ? shift_left_1 : q_reg;
    2'b01: next_q = (ena) ? shift_left_8 : q_reg;
    2'b10: next_q = (ena) ? shift_right_1 : q_reg;
    2'b11: next_q = (ena) ? shift_right_8 : q_reg;
    default: next_q = q_reg;
  endcase
  
  if (load) next_q = data;
end

// Update the state on every clock cycle
always @(posedge clk) begin
  q_reg <= next_q;
end

assign q = q_reg;

endmodule