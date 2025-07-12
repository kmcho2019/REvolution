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

// Barrel shifter for left shift operations
wire [63:0] left_shifted_q;
assign left_shifted_q = (shift_amount == 2'b00)? {q_reg[62:0], 1'b0} :
                         (shift_amount == 2'b01)? {q_reg[55:0], 8'd0} :
                         q_reg;

// Arithmetic right shifter for right shift operations
wire [63:0] right_shifted_q;
assign right_shifted_q = (shift_amount == 2'b10)? {q_reg[63], q_reg[63:1]} :
                         (shift_amount == 2'b11)? {{8{q_reg[63]}}, q_reg[63:8]} :
                         q_reg;

// Next state logic
wire [63:0] next_q;
assign next_q = (load) ? data :
                 (ena && shift_left) ? left_shifted_q :
                 (ena && shift_right) ? right_shifted_q :
                 q_reg;

// Update state on clock edge
always @(posedge clk) begin
    q_reg <= next_q;
end

// Output assignment
assign q = q_reg;

endmodule