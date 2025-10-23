module TopModule (
    input  clk,
    input  x,
    output z
);

reg xor_out, and_out, or_out;  // D flip-flop outputs
reg d_x, d_and, d_or;         // D inputs to the flip-flops

// Continuous assignments for the gates
assign d_x = x ^ xor_out;
assign d_and = x & ~and_out;
assign d_or = x | ~or_out;

// D flip-flop logic
always @(posedge clk) begin
    xor_out <= d_x;
    and_out <= d_and;
    or_out <= d_or;
end

// Continuous assignment for the NOR gate
assign z = ~(xor_out | and_out | or_out);

// Initialize flip-flop outputs to 0
initial begin
    xor_out = 0;
    and_out = 0;
    or_out = 0;
end

endmodule