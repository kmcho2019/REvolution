module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define states
localparam S_WALK_LEFT = 3'b000;
localparam S_WALK_RIGHT = 3'b001;
localparam S_FALLING = 3'b010;
localparam S_DIGGING = 3'b011;
localparam S_SPLATTERED = 3'b100;

reg [2:0] state, next_state;
reg [5:0] fall_counter, next_fall_counter;
reg walk_left_reg, walk_right_reg, aaah_reg, digging_reg;

// Output logic
always_comb begin
    walk_left = walk_left_reg;
    walk_right = walk_right_reg;
    aaah = aaah_reg;
    digging = digging_reg;
end

// State machine logic
always_comb begin
    // Default values
    next_state = state;
    walk_left_reg = (state == S_WALK_LEFT) ? 1'b1 : 1'b0;
    walk_right_reg = (state == S_WALK_RIGHT) ? 1'b1 : 1'b0;
    aaah_reg = (state == S_FALLING) ? 1'b1 : 1'b0;
    digging_reg = (state == S_DIGGING) ? 1'b1 : 1'b0;
    next_fall_counter = (state == S_FALLING) ? fall_counter + 1 : 6'd0;

    case (state)
        S_WALK_LEFT: begin
            if (!ground) begin
                next_state = S_FALLING;
            end else if (dig) begin
                next_state = S_DIGGING;
            end else if (bump_left) begin
                next_state = S_WALK_RIGHT;
            end else if (bump_right) begin
                // No change in state
            end
        end

        S_WALK_RIGHT: begin
            if (!ground) begin
                next_state = S_FALLING;
            end else if (dig) begin
                next_state = S_DIGGING;
            end else if (bump_left) begin
                // No change in state
            end else if (bump_right) begin
                next_state = S_WALK_LEFT;
            end
        end

        S_FALLING: begin
            if (ground) begin
                if (fall_counter > 6'd20) begin
                    next_state = S_SPLATTERED;
                end else begin
                    // Resume walking in the same direction as before the fall
                    if (walk_left_reg) begin
                        next_state = S_WALK_LEFT;
                    end else begin
                        next_state = S_WALK_RIGHT;
                    end
                end
            end
        end

        S_DIGGING: begin
            if (!ground) begin
                next_state = S_FALLING;
                walk_left_reg = (state == S_DIGGING && walk_left_reg) ? 1'b1 : 1'b0;
                walk_right_reg = (state == S_DIGGING && walk_right_reg) ? 1'b1 : 1'b0;
            end
        end

        S_SPLATTERED: begin
            // Stay in this state forever
        end

        default: begin
            // Default state
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S_WALK_LEFT;
        fall_counter <= 6'd0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

endmodule