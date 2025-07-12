module TopModule(
    input clk,
    input x,
    output z
);

reg q1 = 1'b0;
reg q2 = 1'b0;
reg q3 = 1'b0;

assign z = ~(q1 | q2 | q3);

always @(posedge clk) begin
    q1 <= x ^ q1;
    q2 <= x & ~q2;
    q3 <= x | ~q3;
end

endmodule