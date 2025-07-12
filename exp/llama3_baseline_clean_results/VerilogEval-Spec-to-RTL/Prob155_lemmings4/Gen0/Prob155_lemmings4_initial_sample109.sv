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

// Define the states of the state machine
enum logic [2:0] {
    IDLE_LEFT = 3'b001,
    IDLE_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING = 3'b100,
    SPLATTERED = 3'b101
} state, next_state;

// Define a variable to keep track of the number of clock cycles the Lemming has been falling
logic [5:0] fall_count;

// Sequential logic to update the state and fall count
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_count <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_count <= fall_count + 1;
        end else begin
            fall_count <= 0;
        end
    end
end

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                // Do nothing
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                // Do nothing
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if (state == FALLING && dig) begin
                        next_state = IDLE_LEFT;
                    end else if (state == FALLING && !dig) begin
                        if (bump_left) begin
                            next_state = IDLE_RIGHT;
                        end else if (bump_right) begin
                            next_state = IDLE_LEFT;
                        end else begin
                            if (state == IDLE_LEFT) begin
                                next_state = IDLE_LEFT;
                            end else begin
                                next_state = IDLE_RIGHT;
                            end
                        end
                    end
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            // Do nothing
        end
    endcase
end

// Combinational logic to determine the outputs
always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
        end
        IDLE_RIGHT: begin
            walk_right = 1;
        end
        FALLING: begin
            aaah = 1;
        end
        DIGGING: begin
            digging = 1;
        end
        SPLATTERED: begin
            // Do nothing
        end
    endcase
end

endmodule