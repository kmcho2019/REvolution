module TopModule(
    input  clk,
    input  ar,
    input  d,
    output q
);

reg q_reg;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q_reg <= 0;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule