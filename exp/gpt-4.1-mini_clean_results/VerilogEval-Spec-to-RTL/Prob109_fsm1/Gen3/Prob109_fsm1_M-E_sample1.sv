module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding
    // state[1] = B, state[0] = A
    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        // Default next_state to zero to avoid latches
        next_state = 2'b00;

        if (state[1]) begin
            // Current state is B
            if (in == 1'b0)
                next_state = 2'b01;  // Go to A
            else
                next_state = 2'b10;  // Stay at B
        end else if (state[0]) begin
            // Current state is A
            if (in == 1'b0)
                next_state = 2'b10;  // Go to B
            else
                next_state = 2'b01;  // Stay at A
        end else begin
            // No valid state; reset to B
            next_state = 2'b10;
        end
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b10;  // Reset to B
        end else begin
            state <= next_state;
        end
    end

    // Moore output depends on state B only
    assign out = state[1];

endmodule