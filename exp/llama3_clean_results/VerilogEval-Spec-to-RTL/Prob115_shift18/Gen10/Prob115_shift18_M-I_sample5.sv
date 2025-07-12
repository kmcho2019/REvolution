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
wire shift_left;
wire shift_right;
wire shift_by_1;
wire shift_by_8;

assign shift_left = (amount[1] == 1'b0);
assign shift_right = (amount[1] == 1'b1);
assign shift_by_1 = (amount[0] == 1'b0);
assign shift_by_8 = (amount[0] == 1'b1);

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
wire [63:0] shifted_q;
assign shifted_q = (shift_left) ?
                    (shift_by_1) ? left_shifted_q_1 :
                    left_shifted_q_8 :
                    (shift_by_1) ? right_shifted_q_1 :
                    right_shifted_q_8;

assign next_q = (load) ? data :
                (ena) ? shifted_q : q_reg;

// Clock gating
wire clk_gated;
assign clk_gated = ena ? clk : 1'b0;

// Sequential logic
always @(posedge clk_gated or posedge load) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= next_q;
    end
end

assign q = q_reg;

endmodule