module TopModule (
    input  clk,
    input  x,
    output z
);

    // State register vector: bit 2 = q_xor, bit 1 = q_and, bit 0 = q_or
    reg [2:0] state;

    // Combinational logic for D inputs of flip-flops
    wire d_xor = x ^ state[2];        // XOR with q_xor
    wire d_and = x & (~state[1]);     // AND with complement of q_and
    wire d_or  = x | (~state[0]);     // OR with complement of q_or

    // Next state vector combining all flip-flop inputs
    wire [2:0] next_state = {d_xor, d_and, d_or};

    // Flip-flops: synchronous update on positive edge of clk, no reset
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output z: NOR of all flip-flop outputs
    assign z = ~(state[2] | state[1] | state[0]);

endmodule