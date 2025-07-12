module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 2-bit shift register where:
    // reg[1] = current state (1=B, 0=A)
    // reg[0] = previous state
    reg [1:0] state_history;

    // Shift register implementation of state transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_history <= 2'b11; // Reset to state B (1) with history
        end else begin
            // Shift in new state based on current state and input
            state_history <= {state_history[0], 
                            (state_history[1] ? (in ? 1'b1 : 1'b0) 
                                             : (in ? 1'b0 : 1'b1))};
        end
    end

    // Output is current state (MSB of shift register)
    assign out = state_history[1];

endmodule