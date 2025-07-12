module TopModule (
    input clk,
    input rst_n,    // Active-low asynchronous reset
    input x,
    output z
);

    // 3-bit state register: [xor_state, and_state, or_state]
    reg [2:0] state;

    // Next state computation
    wire [2:0] next_state;
    assign next_state[0] = x ^ state[0];      // XOR path
    assign next_state[1] = x & ~state[1];     // AND path
    assign next_state[2] = x | ~state[2];     // OR path

    // State update with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 3'b000;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign z = ~(|state);  // NOR of all state bits

endmodule