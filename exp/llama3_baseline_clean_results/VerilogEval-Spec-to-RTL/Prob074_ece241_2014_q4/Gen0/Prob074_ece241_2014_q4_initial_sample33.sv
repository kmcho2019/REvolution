module TopModule(
    input clk,
    input x,
    output z
);

reg q0, q1, q2;

assign z = ~(q0 | q1 | q2);

always @(posedge clk) begin
    q0 <= x ^ q0;
    q1 <= x & ~q1;
    q2 <= x | ~q2;
end

initial begin
    q0 = 1'b0;
    q1 = 1'b0;
    q2 = 1'b0;
end

endmodule