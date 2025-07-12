module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;
wire [63:0] shift_left_1, shift_left_8, shift_right_1, shift_right_8;

assign shift_left_1 = {q_reg[62:0], 1'b0};
assign shift_left_8 = {q_reg[55:0], 8'd0};
assign shift_right_1 = {q_reg[63], q_reg[63:1]};
assign shift_right_8 = {{8{q_reg[63]}}, q_reg[63:8]};

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        case (amount)
            2'b00: q_reg <= shift_left_1;
            2'b01: q_reg <= shift_left_8;
            2'b10: q_reg <= shift_right_1;
            2'b11: q_reg <= shift_right_8;
            default: q_reg <= q_reg;
        endcase
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule