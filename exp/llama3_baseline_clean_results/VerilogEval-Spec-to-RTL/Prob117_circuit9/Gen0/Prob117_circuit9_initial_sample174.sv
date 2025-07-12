module TopModule (
    input  clk,
    input  a,
    output [2:0] q
);

reg [2:0] q_reg;

always @(posedge clk) begin
    if (a) begin
        q_reg <= 4;
    end else begin
        q_reg <= q_reg + 1;
        if (q_reg == 4) begin
            q_reg <= 0;
        end
    end
end

assign q = q_reg;

endmodule