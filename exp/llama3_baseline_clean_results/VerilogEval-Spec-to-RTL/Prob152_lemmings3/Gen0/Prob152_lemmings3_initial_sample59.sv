module TopModule (
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

// Define states
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING} state, next_state;

// Define original walking direction when falling or digging
logic [1:0] original_direction;

always_comb begin
    // Initialize next state and outputs
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    // Determine next state and outputs based on current state and inputs
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            if (!ground) begin
                next_state = FALLING;
                original_direction = 2'b00; // left
            end else if (dig && ground) begin
                next_state = DIGGING;
                original_direction = 2'b00; // left
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1'b1;
            if (!ground) begin
                next_state = FALLING;
                original_direction = 2'b01; // right
            end else if (dig && ground) begin
                next_state = DIGGING;
                original_direction = 2'b01; // right
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (original_direction == 2'b00) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule