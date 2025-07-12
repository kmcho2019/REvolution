module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;
wire [63:0] next_q;

// Control unit to determine shift operation
wire shift_left_1;
wire shift_left_8;
wire shift_right_1;
wire shift_right_8;

assign shift_left_1 = (amount == 2'b00);
assign shift_left_8 = (amount == 2'b01);
assign shift_right_1 = (amount == 2'b10);
assign shift_right_8 = (amount == 2'b11);

// Barrel shifter for left shift operations
wire [63:0] left_shifted_q_1;
wire [63:0] left_shifted_q_8;
assign left_shifted_q_1 = {q_reg[62:0], 1'b0};
assign left_shifted_q_8 = {q_reg[55:0], 8'd0};

// Arithmetic right shifter for right shift operations
wire [63:0] right_shifted_q_1;
wire [63:0] right_shifted_q_8;
assign right_shifted_q_1 = {q_reg[63], q_reg[63:1]};
assign right_shifted_q_8 = {{8{q_reg[63]}}, q_reg[63:8]};

// Next state logic
assign next_q = (load) ? data :
                (ena) ?
                    (shift_left_1) ? left_shifted_q_1 :
                    (shift_left_8) ? left_shifted_q_8 :
                    (shift_right_1) ? right_shifted_q_1 :
                    (shift_right_8) ? right_shifted_q_8 :
                    q_reg
                : q_reg;

// Sequential logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= next_q;
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule