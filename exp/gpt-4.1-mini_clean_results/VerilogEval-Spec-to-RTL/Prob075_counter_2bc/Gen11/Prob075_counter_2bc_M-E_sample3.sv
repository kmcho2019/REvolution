module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        train_valid,
    input  wire        train_taken,
    output reg  [1:0]  state
);

    wire [2:0] next_state; // 3 bits to hold incremented/decremented value safely
    wire enable_update;

    assign enable_update = train_valid;

    // Calculate next_state with saturation
    assign next_state = (enable_update) ?
        (train_taken ? 
            ((state == 2'd3) ? 3'd3 : state + 3'd1) :  // saturate increment at 3
            ((state == 2'd0) ? 3'd0 : state - 3'd1)    // saturate decrement at 0
        ) : state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (enable_update && (state != next_state[1:0])) begin
            // Update only if the state changes to reduce toggling
            state <= next_state[1:0];
        end
    end

endmodule