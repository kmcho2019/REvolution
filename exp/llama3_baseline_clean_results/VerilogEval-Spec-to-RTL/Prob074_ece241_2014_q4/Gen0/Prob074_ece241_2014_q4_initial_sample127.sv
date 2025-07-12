module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff;

// Initial values of the flip-flops
initial begin
    xor_ff = 0;
    and_ff = 0;
    or_ff = 0;
end

// Describe the behavior of the D flip-flops
always @(posedge clk) begin
    xor_ff <= x ^ xor_ff;
    and_ff <= x & ~and_ff;
    or_ff <= x | ~or_ff;
end

// Connect the outputs of the flip-flops to a three-input NOR gate
assign z = ~(xor_ff | and_ff | or_ff);

endmodule