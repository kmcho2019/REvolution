module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_out, and_out, or_out;
reg q_xor, q_and, q_or;

initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
    z =; // Initialize z to a default value
end

always @(posedge clk) begin
    xor_out = x ^ q_xor;
    and_out = x & ~q_and;
    or_out = x | ~q_or;

    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;

    // Update z inside the always block to ensure it's calculated based on the current values
    z <= ~(xor_out | and_out | or_out);
end

endmodule