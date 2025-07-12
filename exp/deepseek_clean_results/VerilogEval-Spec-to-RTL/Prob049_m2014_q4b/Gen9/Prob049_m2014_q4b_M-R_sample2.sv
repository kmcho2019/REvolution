module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg;

assign q = q_reg;

always @(posedge clk or posedge ar) begin
    if (ar) q_reg <= 1'b0;
    else q_reg <= d;
end

endmodule