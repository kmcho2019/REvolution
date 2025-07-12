module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg;

always @(posedge clk) begin
    q_reg <= d;
end

assign q = ar ? 1'b0 : q_reg;

endmodule