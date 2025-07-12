module TopModule(
    input clk,
    input x,
    output reg z
);

reg q_xor, q_and, q_or;

initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
    z = 1; // Initialize z to a default value
end

always @(posedge clk) begin
    reg xor_out, and_out, or_out;

    xor_out = x ^ q_xor;
    and_out = x & ~q_and;
    or_out = x | ~q_or;

    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

always @(*) begin
    z = ~(q_xor | q_and | q_or); // Calculate z based on updated q values
end

endmodule