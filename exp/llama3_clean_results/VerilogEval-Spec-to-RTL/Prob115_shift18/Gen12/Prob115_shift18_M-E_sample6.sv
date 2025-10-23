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

// Recursive barrel shifter for left shift operations
wire [63:0] left_shifted_q;
assign left_shifted_q = (shift_amount == 2'b00)? {q_reg[62:0], 1'b0} :
                         (shift_amount == 2'b01)? {q_reg[55:0], 8'd0} :
                         q_reg;

// Arithmetic right shifter for right shift operations
wire [63:0] right_shifted_q;
assign right_shifted_q = (shift_amount == 2'b10)? {q_reg[63], q_reg[63:1]} :
                         (shift_amount == 2'b11)? {{8{q_reg[63]}}, q_reg[63:8]} :
                         q_reg;

// Hybrid shift logic
wire [63:0] shifted_q;
assign shifted_q = (shift_left)? left_shifted_q :
                   (shift_right)? right_shifted_q :
                   q_reg;

// Sequential logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= shifted_q;
    end
end

assign q = q_reg;

endmodule