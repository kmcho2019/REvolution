module TopModule (
    input clk,
    input x,
    output z
);

    // Combined state register [xor_ff, and_ff, or_ff]
    reg [2:0] state;
    wire xor_ff = state[2];
    wire and_ff = state[1];
    wire or_ff = state[0];

    // Next state logic
    wire [2:0] next_state;
    assign next_state[2] = x ^ xor_ff;          // XOR gate
    assign next_state[1] = x & ~and_ff;        // AND gate
    assign next_state[0] = x | ~or_ff;         // OR gate

    // State update with synchronous reset
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic
    assign z = ~(|state);  // NOR of all state bits

    // Alternative implementation with explicit reset (optional)
    // always @(posedge clk) begin
    //     if (reset) state <= 3'b0;
    //     else state <= next_state;
    // end

endmodule