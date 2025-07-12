module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;

// Control unit to determine shift operation
wire [1:0] shift_amount;
wire shift_left;
wire shift_right;

assign shift_amount = amount;
assign shift_left = (amount == 2'b00 || amount == 2'b01);
assign shift_right = (amount == 2'b10 || amount == 2'b11);

// Hierarchical shifter structure
wire [63:0] left_shifted_q;
wire [63:0] right_shifted_q;

// 1-bit left shifter
assign left_shifted_q = (shift_amount == 2'b00)? {q_reg[62:0], 1'b0} : q_reg;

// 8-bit left shifter
wire [63:0] left_shifted_q_8;
assign left_shifted_q_8 = (shift_amount == 2'b01)? {q_reg[55:0], 8'd0} : q_reg;

// 1-bit right shifter (arithmetic)
assign right_shifted_q = (shift_amount == 2'b10)? {q_reg[63], q_reg[63:1]} : q_reg;

// 8-bit right shifter (arithmetic)
wire [63:0] right_shifted_q_8;
assign right_shifted_q_8 = (shift_amount == 2'b11)? {{8{q_reg[63]}}, q_reg[63:8]} : q_reg;

// Multiplexer-based hierarchical shifter
assign q_reg = (load)? data :
               (ena && shift_left)? ((shift_amount == 2'b00)? left_shifted_q : left_shifted_q_8) :
               (ena && shift_right)? ((shift_amount == 2'b10)? right_shifted_q : right_shifted_q_8) :
               q_reg;

// Sequential logic
always @(posedge clk) begin
    q <= q_reg;
end

endmodule