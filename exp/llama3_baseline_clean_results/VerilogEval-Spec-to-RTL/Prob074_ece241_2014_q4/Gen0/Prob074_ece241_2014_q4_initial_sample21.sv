module TopModule(
    input clk,
    input x,
    output z
);

reg q_x, q_and, q_or;

assign z = ~(q_x | q_and | q_or);

always @(posedge clk) begin
    q_x <= x ^ q_x;
    q_and <= x & ~q_and;
    q_or <= x | ~q_or;
end

initial begin
    q_x <= 1'b0;
    q_and <= 1'b0;
    q_or <= 1'b0;
end

endmodule