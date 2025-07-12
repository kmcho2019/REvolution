module TopModule(
    input clk,
    input x,
    output z
);

reg q1, q2, q3;

assign z = ~(q1 | q2 | q3);

always @(posedge clk) begin
    q1 <= x ^ q1;
    q2 <= x & ~q2;
    q3 <= x | ~q3;
end

initial begin
    q1 = 1'b0;
    q2 = 1'b0;
    q3 = 1'b0;
end

endmodule