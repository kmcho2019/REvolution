module TopModule (
    input clk,
    input x,
    output reg z
);
    // 3-bit state register: bit 2 = q_xor, bit 1 = q_and, bit 0 = q_or
    reg [2:0] state;

    // Initialize flip-flops to zero at simulation start
    initial begin
        state = 3'b000;
    end

    always @(posedge clk) begin
        // Calculate next states according to gate inputs and current state bits
        // q_xor_next = x XOR q_xor
        // q_and_next = x AND (NOT q_and)
        // q_or_next  = x OR (NOT q_or)

        state[2] <= x ^ state[2];
        state[1] <= x & (~state[1]);
        state[0] <= x | (~state[0]);
    end

    always @(*) begin
        // Output z is NOR of the three flip-flop outputs
        z = ~(state[2] | state[1] | state[0]);
    end
endmodule