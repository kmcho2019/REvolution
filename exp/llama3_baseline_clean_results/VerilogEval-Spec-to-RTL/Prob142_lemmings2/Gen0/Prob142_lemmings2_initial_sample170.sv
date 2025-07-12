module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Enum for states
enum logic [1:0] { IDLE_LEFT, IDLE_RIGHT, FALLING } state, next_state;

// Variable to keep track of the current direction when falling
logic [1:0] fall_direction;

always_comb begin
    // Determine next state based on current state and inputs
    case (state)
        IDLE_LEFT: begin
            if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT; // no change, already walking left
            end else if (~ground) begin
                next_state = FALLING;
                fall_direction = IDLE_LEFT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (~ground) begin
                next_state = FALLING;
                fall_direction = IDLE_RIGHT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = fall_direction;
            end else begin
                next_state = FALLING;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    // Determine output signals based on current state
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule