module TopModule(
    input clk,
    input x,
    output z
);

reg q_x, q_and, q_or;  // Outputs of the D flip-flops

always @(posedge clk) begin
    q_x <= x ^ q_x;
    q_and <= x & ~q_and;
    q_or <= x | ~q_or;
end

assign z = ~(q_x | q_and | q_or);

initial begin
    q_x = 0;
    q_and = 0;
    q_or = 0;
end

endmodule