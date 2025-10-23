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
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// Declare the current state and next state
reg [1:0] state, next_state;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                // If the Lemming was walking left before falling, it will resume walking left
                // If the Lemming was walking right before falling, it will resume walking right
                // If the Lemming was digging before falling, it will resume walking in the same direction as before digging
                if (bump_left && !bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right && !bump_left) begin
                    next_state = WALK_LEFT;
                end else if (bump_left && bump_right) begin
                    next_state = WALK_LEFT;
                end else if (state == DIGGING) begin
                    // We don't know the previous direction when digging, so we will assume it was walking left
                    next_state = WALK_LEFT;
                end else begin
                    // We don't know the previous direction when falling, so we will assume it was walking left
                    next_state = WALK_LEFT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Output logic
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule