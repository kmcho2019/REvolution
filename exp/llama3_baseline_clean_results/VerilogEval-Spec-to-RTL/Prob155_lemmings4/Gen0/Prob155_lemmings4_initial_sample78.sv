module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// State encoding: 3'b000 - WALK_LEFT, 3'b001 - WALK_RIGHT, 3'b010 - FALL, 3'b011 - DIG, 3'b100 - SPLATTER
reg [2:0] state;
reg [1:0] direction;  // 2'b00 - left, 2'b01 - right
reg [5:0] fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 3'b000;  // Reset to WALK_LEFT
        direction <= 2'b00;  // Initial direction is left
        fall_counter <= 6'b000000;  // Reset fall counter
    end else begin
        case (state)
            3'b000: begin  // WALK_LEFT
                if (!ground) begin
                    state <= 3'b010;  // Start falling
                    fall_counter <= 6'b000001;  // Initialize fall counter
                end else if (dig) begin
                    state <= 3'b011;  // Start digging
                end else if (bump_left) begin
                    direction <= 2'b01;  // Switch to right
                    state <= 3'b001;  // Switch to WALK_RIGHT
                end else if (bump_right) begin
                    // Do nothing, already walking left
                end
            end
            3'b001: begin  // WALK_RIGHT
                if (!ground) begin
                    state <= 3'b010;  // Start falling
                    fall_counter <= 6'b000001;  // Initialize fall counter
                end else if (dig) begin
                    state <= 3'b011;  // Start digging
                end else if (bump_right) begin
                    direction <= 2'b00;  // Switch to left
                    state <= 3'b000;  // Switch to WALK_LEFT
                end else if (bump_left) begin
                    // Do nothing, already walking right
                end
            end
            3'b010: begin  // FALL
                fall_counter <= fall_counter + 6'b000001;  // Increment fall counter
                if (ground) begin
                    if (fall_counter >= 6'b101000) begin
                        state <= 3'b100;  // Splatter
                    end else begin
                        state <= (direction == 2'b00) ? 3'b000 : 3'b001;  // Resume walking
                    end
                end
            end
            3'b011: begin  // DIG
                if (!ground) begin
                    state <= 3'b010;  // Start falling
                    fall_counter <= 6'b000001;  // Initialize fall counter
                end
            end
            3'b100: begin  // SPLATTER
                // Do nothing, stay in this state
            end
        endcase
    end
end

always @(*) begin
    case (state)
        3'b000: begin  // WALK_LEFT
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        3'b001: begin  // WALK_RIGHT
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        3'b010: begin  // FALL
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        3'b011: begin  // DIG
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        3'b100: begin  // SPLATTER
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule