module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);
    genvar i;
    reg [7:0] q_reg;

    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bit
            always @(posedge clk) begin
                q_reg[i] <= d[i];
            end
        end
    endgenerate

    assign q = q_reg;

endmodule