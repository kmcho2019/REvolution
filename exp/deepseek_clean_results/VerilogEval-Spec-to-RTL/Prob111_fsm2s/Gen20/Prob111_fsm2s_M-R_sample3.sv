module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding (bit 0: OFF, bit 1: ON)
    reg [1:0] state, next_state;

    // State transition logic using continuous assignments
    assign next_state[0] = (~reset) & ((state[0] & ~j) | (state[1] & k);
    assign next_state[1] = (~reset) & ((state[0] & j) | (state[1] & ~k));

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b01;  // Reset to OFF state
        end else begin
            state <= next_state;
        end
    end

    // Output logic - ON state is when state[1] is high
    assign out = state[1];

endmodule