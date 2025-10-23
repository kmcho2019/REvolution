module TopModule (
    input clk,
    input x,
    output z
);

    // 3-bit register: [xor_state, and_state, or_state]
    reg [2:0] state = 3'b000;  // Initialized to 0 as specified

    // Next state computation
    wire [2:0] next_state;
    assign next_state[2] = x ^ state[2];      // XOR gate
    assign next_state[1] = x & ~state[1];     // AND gate
    assign next_state[0] = x | ~state[0];     // OR gate

    // State update on clock edge
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output is NOR of all state bits
    assign z = ~(|state);

endmodule