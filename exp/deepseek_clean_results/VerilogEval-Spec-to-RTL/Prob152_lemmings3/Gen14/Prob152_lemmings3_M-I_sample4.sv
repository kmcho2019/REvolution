module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // Combined state and direction encoding (2 bits total)
    // [1]: 0=WALK, 1=non-WALK (FALL/DIG)
    // [0]: direction when WALK, state when non-WALK (0=FALL, 1=DIG)
    reg [1:0] state_dir;

    // Next state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_dir <= 2'b00; // WALK left
        end else begin
            case (state_dir)
                2'b00: begin // WALK left
                    if (~ground) begin
                        state_dir <= 2'b10; // FALL (preserve left)
                    end else if (dig) begin
                        state_dir <= 2'b11; // DIG (preserve left)
                    end
                end
                2'b01: begin // WALK right
                    if (~ground) begin
                        state_dir <= 2'b10; // FALL (preserve right)
                    end else if (dig) begin
                        state_dir <= 2'b11; // DIG (preserve right)
                    end
                end
                2'b10: begin // FALL
                    if (ground) begin
                        // Return to previous walking direction
                        state_dir <= {1'b0, state_dir[0]};
                    end
                end
                2'b11: begin // DIG
                    if (~ground) begin
                        state_dir <= 2'b10; // FALL
                    end
                end
            endcase
        end
    end

    // Direction update logic (only in WALK state)
    always @(posedge clk) begin
        if (~state_dir[1]) begin // Only in WALK state
            if (bump_left) begin
                state_dir[0] <= 1'b1; // Switch to right
            end else if (bump_right) begin
                state_dir[0] <= 1'b0; // Switch to left
            end
        end
    end

    // Registered outputs for power optimization
    always @(posedge clk) begin
        walk_left  <= (state_dir == 2'b00);
        walk_right <= (state_dir == 2'b01);
        aaah       <= (state_dir == 2'b10);
        digging    <= (state_dir == 2'b11);
    end

endmodule