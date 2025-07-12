module TopModule(
    input  clk,
    input  x,
    output z
);

reg q_x, q_and, q_or; // outputs of the D flip-flops
wire d_x, d_and, d_or; // inputs of the D flip-flops

// Gate descriptions
assign d_x = x ^ q_x;
assign d_and = x & ~q_and;
assign d_or = x | ~q_or;

// D flip-flops
always @(posedge clk) begin
    q_x <= d_x;
    q_and <= d_and;
    q_or <= d_or;
end

// Output description
assign z = ~(q_x | q_and | q_or);

// Initial values for the flip-flops
initial begin
    q_x = 0;
    q_and = 0;
    q_or = 0;
end

endmodule