module TopModule (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output [7:0]  q
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : DFF_BIT
            reg q_reg;
            always @(posedge clk or posedge areset) begin
                if (areset)
                    q_reg <= 1'b0;
                else
                    q_reg <= d[i];
            end
            assign q[i] = q_reg;
        end
    endgenerate
endmodule