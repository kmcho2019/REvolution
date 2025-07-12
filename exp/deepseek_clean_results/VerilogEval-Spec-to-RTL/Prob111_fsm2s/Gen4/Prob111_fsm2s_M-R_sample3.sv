module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state encoding (even though only 2 states)
    reg [1:0] state;  // state[0] = OFF, state[1] = ON
    wire [1:0] next_state;

    // Next state logic
    assign next_state[0] = (state[0] & ~j) | (state[1] & k);
    assign next_state[1] = (state[0] & j) | (state[1] & ~k);

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= 2'b01;  // Reset to OFF state
        else
            state <= next_state;
    end

    // Output logic (Moore style)
    assign out = state[1];

endmodule