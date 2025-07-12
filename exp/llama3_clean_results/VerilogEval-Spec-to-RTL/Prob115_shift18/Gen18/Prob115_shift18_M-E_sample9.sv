module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

// Shift left by 1 bit
wire [63:0] shift_left_1 = (q_reg << 1);

// Shift left by 8 bits
wire [63:0] shift_left_8 = (q_reg << 8);

// Shift right by 1 bit (arithmetic right shift)
wire [63:0] shift_right_1 = {q_reg[63], q_reg[63:1]};

// Shift right by 8 bits (arithmetic right shift)
wire [63:0] shift_right_8 = {{8{q_reg[63]}}, q_reg[63:8]};

// Select between left and right shift
wire [63:0] shift_left = (amount[0]) ? shift_left_8 : shift_left_1;
wire [63:0] shift_right = (amount[0]) ? shift_right_8 : shift_right_1;

// Select between left and right shift operation
wire [63:0] shift_q = (amount[1]) ? shift_right : shift_left;

// Sequential logic
always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else if (ena) begin
    q_reg <= shift_q;
  end
end

assign q = q_reg;

endmodule