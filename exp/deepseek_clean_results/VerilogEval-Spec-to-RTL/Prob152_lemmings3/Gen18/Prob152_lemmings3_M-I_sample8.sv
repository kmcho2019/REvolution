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
    // [1]: 0=WALK/DIG, 1=FALL
    // [0]: When WALK/DIG: 0=left, 1=right
    reg [1:0] state_dir;

    // Separate direction register (only updated in WALK state)
    wire is_walking = ~state_dir[1] & ground;
    wire current_dir = state_dir[0];

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_dir <= 2'b00; // WALK left
        end else begin
            casez ({state_dir[1], ground, dig})
                3'b0_0_?: state_dir <= {1'b1, current_dir}; // FALL
                3'b0_1_1: state_dir <= {1'b0, current_dir};  // DIG (keep dir)
                3'b0_1_0: state_dir <= {1'b0, current_dir};  // WALK (dir may change)
                3'b1_1_?: state_dir <= {1'b0, current_dir};  // FALL->WALK
                default: state_dir <= state_dir;              // Keep state
            endcase
        end
    end

    // Direction update logic (only in WALK state)
    always @(posedge clk) begin
        if (is_walking) begin
            if (bump_left) state_dir[0] <= 1'b1;
            else if (bump_right) state_dir[0] <= 1'b0;
        end
    end

    // Registered outputs for better timing/power
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            {walk_left, walk_right, aaah, digging} <= 4'b1000;
        end else begin
            walk_left  <= is_walking & ~current_dir;
            walk_right <= is_walking & current_dir;
            aaah       <= state_dir[1];
            digging    <= ~state_dir[1] & ~is_walking & ground;
        end
    end

endmodule