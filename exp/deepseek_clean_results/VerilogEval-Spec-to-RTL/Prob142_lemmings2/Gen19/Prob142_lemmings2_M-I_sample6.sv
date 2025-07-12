module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding optimization:
    // bit 1: 0=WALK, 1=FALL
    // bit 0: direction (0=left, 1=right)
    reg [1:0] state;
    reg ground_sync;

    // Input synchronization
    reg bump_left_sync, bump_right_sync;
    always @(posedge clk) begin
        bump_left_sync <= bump_left;
        bump_right_sync <= bump_right;
        ground_sync <= ground;
    end

    // Combined direction toggle signal
    wire direction_toggle = (bump_left_sync & ~state[0]) | (bump_right_sync & state[0]);

    // Clock gating logic
    wire state_change_needed = (~ground_sync & ~state[1]) |  // Start falling
                             (ground_sync & state[1]) |     // Stop falling
                             (direction_toggle & ground_sync & ~state[1]); // Change direction

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b00; // Reset to walk left
        end else if (state_change_needed) begin
            case (state[1])
                1'b0: begin // Walking
                    if (~ground_sync) begin
                        state <= {1'b1, state[0]}; // Start falling
                    end else if (direction_toggle) begin
                        state[0] <= ~state[0]; // Toggle direction
                    end
                end
                1'b1: begin // Falling
                    if (ground_sync) begin
                        state <= {1'b0, state[0]}; // Resume walking
                    end
                end
            endcase
        end
    end

    // Optimized output logic
    assign walk_left = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];
    assign aaah = state[1];

endmodule