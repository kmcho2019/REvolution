module TopModule (
    input clk,
    input x,
    output z
);

    // 3-bit state register: [xor_state, and_state, or_state]
    reg [2:0] state = 3'b000;

    // Next state computation
    wire [2:0] next_state;
    assign next_state[0] = x ^ state[0];      // XOR path
    assign next_state[1] = x & ~state[1];     // AND path
    assign next_state[2] = x | ~state[2];     // OR path

    // State update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic
    assign z = ~(|state);  // NOR of all state bits

endmodule