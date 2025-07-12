module TopModule (
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    always @(posedge clk) begin
        q_xor <= x ^ q_xor;    // XOR with feedback
        q_and <= x & ~q_and;    // AND with inverted feedback
        q_or <= x | ~q_or;      // OR with inverted feedback
    end

    assign z = ~(q_xor | q_and | q_or);  // 3-input NOR

endmodule