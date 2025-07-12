module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        train_valid,
    input  wire        train_taken,
    output reg  [1:0]  state
);

    reg [1:0] next_state;
    wire      update_enable;

    // Compute next_state combinationally with saturation
    always @(*) begin
        if (!train_valid) begin
            next_state = state;
        end else if (train_taken) begin
            // Saturating increment
            if (state == 2'd3)
                next_state = 2'd3;
            else
                next_state = state + 1;
        end else begin
            // Saturating decrement
            if (state == 2'd0)
                next_state = 2'd0;
            else
                next_state = state - 1;
        end
    end

    // Update enable to reduce toggling when next_state == state
    assign update_enable = (next_state != state);

    // Sequential logic with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (update_enable) begin
            state <= next_state;
        end
        // else retain state to avoid unnecessary toggle
    end

endmodule