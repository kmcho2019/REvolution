module TopModule(
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

// Define the states
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define the walking direction
logic walking_left;
logic walking_right;

// Define the fall counter
logic [5:0] fall_counter;

// Define the digging flag
logic is_digging;

// Initialize the state and variables
initial begin
    state = WALK_LEFT;
    walking_left = 1'b1;
    walking_right = 1'b0;
    fall_counter = 6'd0;
    is_digging = 1'b0;
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walking_left <= 1'b1;
        walking_right <= 1'b0;
        fall_counter <= 6'd0;
        is_digging <= 1'b0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 6'd1;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                    walking_left <= 1'b0;
                    walking_right <= 1'b1;
                end else if (dig && !is_digging) begin
                    state <= DIGGING;
                    is_digging <= 1'b1;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 6'd1;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                    walking_left <= 1'b1;
                    walking_right <= 1'b0;
                end else if (dig && !is_digging) begin
                    state <= DIGGING;
                    is_digging <= 1'b1;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 6'd1;
                if (ground) begin
                    if (fall_counter > 6'd20) begin
                        state <= SPLATTERED;
                    end else if (walking_left) begin
                        state <= WALK_LEFT;
                    end else begin
                        state <= WALK_RIGHT;
                    end
                    fall_counter <= 6'd0;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 6'd1;
                    is_digging <= 1'b0;
                end
            end
            SPLATTERED: begin
                // Stay in this state forever
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    walk_left = (state == WALK_LEFT || (state == FALLING && walking_left)) ? 1'b1 : 1'b0;
    walk_right = (state == WALK_RIGHT || (state == FALLING && walking_right)) ? 1'b1 : 1'b0;
    aaah = (state == FALLING) ? 1'b1 : 1'b0;
    digging = (state == DIGGING) ? 1'b1 : 1'b0;
end

endmodule