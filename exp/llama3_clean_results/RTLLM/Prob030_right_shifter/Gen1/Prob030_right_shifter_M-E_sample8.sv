module right_shifter(
    input clk,
    input d,
    output [7:0] q
);

    reg [7:0] q_reg;

    always @(posedge clk) begin
        q_reg[7] <= d;
        q_reg[6] <= q_reg[7];
        q_reg[5] <= q_reg[6];
        q_reg[4] <= q_reg[5];
        q_reg[3] <= q_reg[4];
        q_reg[2] <= q_reg[3];
        q_reg[1] <= q_reg[2];
        q_reg[0] <= q_reg[1];
    end

    assign q = q_reg;

    initial begin
        q_reg = 8'b0;
    end

endmodule