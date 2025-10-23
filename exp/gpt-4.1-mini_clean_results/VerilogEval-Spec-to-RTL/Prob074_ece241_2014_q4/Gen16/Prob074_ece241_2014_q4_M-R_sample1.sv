module TopModule (
    input clk,
    input x,
    output z
);

    // Add a synchronous reset signal internally set at start
    reg reset = 1'b1;

    // Separate flip-flop outputs
    reg q_xor, q_and, q_or;

    // Combinational wires for gate outputs feeding flip-flops
    wire d_xor, d_and, d_or;

    // Compute next states according to problem specification
    assign d_xor = x ^ q_xor;        // XOR gate input: x XOR current q_xor
    assign d_and = x & (~q_and);     // AND gate input: x AND NOT q_and
    assign d_or  = x | (~q_or);      // OR gate input: x OR NOT q_or

    // Output is NOR of all three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

    always @(posedge clk) begin
        if (reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            reset <= 1'b0; // release reset after first clock
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

endmodule