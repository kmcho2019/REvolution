module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal flag to indicate reset done after first clock edge
    reg reset_done;

    // Flip-flop state registers
    reg q_xor, q_and, q_or;

    // Combinational logic for the D inputs of flip-flops
    wire d_xor = x ^ q_xor;      // XOR gate: x and q_xor
    wire d_and = x & (~q_and);   // AND gate: x and complement of q_and
    wire d_or  = x | (~q_or);    // OR gate: x and complement of q_or

    always @(posedge clk) begin
        if (!reset_done) begin
            // Initial synchronous reset on first clock edge
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            reset_done <= 1'b1;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule