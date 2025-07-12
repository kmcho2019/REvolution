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

// Define the states of the state machine
enum {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Counter for tracking the duration of the fall
reg [5:0] fall_counter;
reg [5:0] next_fall_counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_counter <= 6'b0;
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
    end
end

always @(*) begin
    next_state = state;
    next_fall_counter = fall_counter;

    case (state)
        IDLE_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                // No action needed, already walking left
            end
        end
        IDLE_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                // No action needed, already walking right
            end
        end
        FALLING: begin
            next_fall_counter = fall_counter + 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    // Resume previous direction, but this is handled in output logic
                    next_state = IDLE_LEFT; // Default, will be overridden
                end
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end else begin
                // Continue digging, state doesn't change
            end
        end
        SPLATTERED: begin
            // No change, splattered state is final
        end
    endcase
end

always @(*) begin
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule