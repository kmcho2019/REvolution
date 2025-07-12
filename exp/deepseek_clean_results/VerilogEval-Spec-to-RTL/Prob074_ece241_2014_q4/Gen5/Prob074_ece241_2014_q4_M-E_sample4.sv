module TopModule (
    input clk,
    input x,
    output z
);

    // 3-bit register: [xor_ff, and_ff, or_ff]
    reg [2:0] state = 3'b000;

    // Feedback logic
    wire xor_fb = state[2];
    wire and_fb = ~state[1];
    wire or_fb = ~state[0];

    // Next state computation
    wire [2:0] next_state = {
        x ^ xor_fb,  // XOR path
        x & and_fb,  // AND path
        x | or_fb    // OR path
    };

    // State update with synchronous reset
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic (NOR of all flip-flop outputs)
    assign z = ~(|state);

endmodule