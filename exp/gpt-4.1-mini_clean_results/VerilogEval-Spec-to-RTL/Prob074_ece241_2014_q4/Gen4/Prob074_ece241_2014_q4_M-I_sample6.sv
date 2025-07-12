module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal reset signal, asserted only on first clock cycle
    reg rst;
    initial rst = 1'b1;  // Start with reset asserted at time 0

    // Flip-flop state registers
    reg q_xor, q_and, q_or;

    // Combinational signals for gate outputs feeding the D inputs of flip-flops
    wire d_xor, d_and, d_or;

    // Compute combinational logic outside always block
    assign d_xor = x ^ q_xor;      // XOR gate: x and q_xor
    assign d_and = x & (~q_and);   // AND gate: x and complement of q_and
    assign d_or  = x | (~q_or);    // OR gate: x and complement of q_or

    // Synchronous reset logic: reset asserted for one cycle then cleared
    always @(posedge clk) begin
        if (rst) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            rst <= 1'b0;  // De-assert reset after first clock edge
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is the NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule