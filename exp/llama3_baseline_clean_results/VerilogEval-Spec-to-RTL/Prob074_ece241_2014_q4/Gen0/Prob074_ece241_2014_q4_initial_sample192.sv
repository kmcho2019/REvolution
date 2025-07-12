module TopModule(
    input clk,
    input x,
    output z
);

reg q1, q2, q3; // outputs of the flip-flops

// Update the flip-flop outputs on the positive edge of the clock
always @(posedge clk) begin
    q1 <= x ^ q1; // XOR gate output
    q2 <= x & ~q2; // AND gate output
    q3 <= x | ~q3; // OR gate output
end

// NOR gate
assign z = ~( (x ^ q1) | (x & ~q2) | (x | ~q3) );

endmodule