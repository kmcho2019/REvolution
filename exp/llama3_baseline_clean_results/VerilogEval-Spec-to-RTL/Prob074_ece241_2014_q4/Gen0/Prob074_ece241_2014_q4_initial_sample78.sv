module TopModule(
    input clk,
    input x,
    output z
);

reg q_x, q_and, q_or; // outputs of the D flip-flops
wire d_x, d_and, d_or; // inputs to the D flip-flops

// Implement the XOR gate
assign d_x = x ^ q_x;

// Implement the AND gate
assign d_and = x & ~q_and;

// Implement the OR gate
assign d_or = x | ~q_or;

// Implement the D flip-flops
always @(posedge clk) begin
    q_x <= d_x;
    q_and <= d_and;
    q_or <= d_or;
end

// Implement the NOR gate
assign z = ~(d_x | d_and | d_or);

initial begin
    q_x = 0;
    q_and = 0;
    q_or = 0;
end

endmodule