module TopModule(
    input  clk,
    input  ar,
    input  d,
    output q
);

reg q_reg;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q_reg <= 1'b0;
    end else if (clk) begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule