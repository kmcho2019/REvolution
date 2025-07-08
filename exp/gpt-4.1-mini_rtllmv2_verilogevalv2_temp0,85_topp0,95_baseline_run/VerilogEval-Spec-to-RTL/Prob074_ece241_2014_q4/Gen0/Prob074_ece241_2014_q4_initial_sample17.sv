module TopModule(
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    // Synchronous reset at initial block for simulation purposes
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    wire d_xor, d_and, d_or;

    // XOR gate: x XOR q_xor
    assign d_xor = x ^ q_xor;

    // AND gate: x AND (~q_and)
    assign d_and = x & (~q_and);

    // OR gate: x OR (~q_or)
    assign d_or = x | (~q_or);

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // NOR gate with the outputs of the three flip-flops
    assign z = ~(q_xor | q_and | q_or);

endmodule