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
enum logic [2:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Define the current direction register
logic current_direction;

// Define the fall counter
logic [5:0] fall_counter, next_fall_counter;

// Define the output logic
assign walk_left = (state == IDLE_LEFT);
assign walk_right = (state == IDLE_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

// Define the state machine logic
always_comb begin
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
                next_state = IDLE_LEFT;
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
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (current_direction) begin
                        next_state = IDLE_LEFT;
                    end else begin
                        next_state = IDLE_RIGHT;
                    end
                end
            end else begin
                next_fall_counter = fall_counter + 1;
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

// Define the sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        current_direction <= 1'b1;
        fall_counter <= 6'd0;
    end else begin
        state <= next_state;
        if ((state == IDLE_LEFT) || (state == FALLING && current_direction == 1'b1)) begin
            current_direction <= 1'b1;
        end else if ((state == IDLE_RIGHT) || (state == FALLING && current_direction == 1'b0)) begin
            current_direction <= 1'b0;
        end
        fall_counter <= next_fall_counter;
    end
end

endmodule