module TopModule(
    input  clk,
    input  d,
    output q
);

reg internal_q;
reg q_reg;

always @(posedge clk or posedge ~clk) begin
    internal_q <= d;
end

assign q = internal_q;

endmodule