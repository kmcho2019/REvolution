module TopModule (
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    // Initial reset to zero
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    wire d_xor, d_and, d_or;

    // XOR D input: x XOR q_xor
    assign d_xor = x ^ q_xor;
    // AND D input: x AND (~q_and)
    assign d_and = x & (~q_and);
    // OR D input: x OR (~q_or)
    assign d_or  = x | (~q_or);

    // Sequential logic
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output Z is NOR of three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule