module DFF(
    input clk,
    input d,
    output q
);

reg q_reg;
always @(posedge clk) begin
    q_reg <= d;
end
assign q = q_reg;

endmodule

module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF u_DFF(
            .clk(clk),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule