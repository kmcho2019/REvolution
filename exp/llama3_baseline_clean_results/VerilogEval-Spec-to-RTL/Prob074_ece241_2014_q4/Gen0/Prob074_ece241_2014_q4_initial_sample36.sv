module TopModule(
    input clk,
    input x,
    output z
);

reg q_x, q_and, q_or;

// D flip-flops
always @(posedge clk) begin
    q_x <= x ^ q_x;
    q_and <= x & ~q_and;
    q_or <= x | ~q_or;
end

// NOR gate
assign z = ~(q_x | q_and | q_or);

endmodule