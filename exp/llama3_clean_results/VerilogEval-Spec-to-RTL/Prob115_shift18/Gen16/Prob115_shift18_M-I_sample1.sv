module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

// Synchronous load
wire [63:0] load_next_q;
assign load_next_q = data;

// Shift left by 1 bit, optimized to reduce area and power
wire [63:0] shift_left_1;
assign shift_left_1 = {q_reg[62:0], 1'b0};

// Shift left by 8 bits, optimized
wire [63:0] shift_left_8;
assign shift_left_8 = {q_reg[55:0], 8'b0};

// Arithmetic right shift by 1 bit, optimized for area
wire [63:0] shift_right_1;
assign shift_right_1 = {q_reg[63], q_reg[63:1]};

// Arithmetic right shift by 8 bits, optimized for area and power
wire [63:0] shift_right_8;
assign shift_right_8 = { {8{q_reg[63]}}, q_reg[63:8] };

// Next state logic, using a case statement for clarity and efficiency
wire [63:0] next_q;
always @(load, ena, amount, q_reg) begin
  case ({ena, amount})
    3'b100: next_q = shift_left_1; // ena, shift left by 1
    3'b101: next_q = shift_left_8; // ena, shift left by 8
    3'b110: next_q = shift_right_1; // ena, shift right by 1
    3'b111: next_q = shift_right_8; // ena, shift right by 8
    default: if (load) next_q = load_next_q; else next_q = q_reg;
  endcase
end

// Update state on clock edge
always @(posedge clk) begin
  q_reg <= next_q;
end

// Output assignment
assign q = q_reg;

endmodule