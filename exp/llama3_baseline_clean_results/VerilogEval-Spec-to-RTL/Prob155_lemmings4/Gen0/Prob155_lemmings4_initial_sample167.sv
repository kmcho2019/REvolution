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

// Counter to keep track of the number of clock cycles the Lemming has been falling
logic [4:0] fall_count;

// Output signals
logic walk_left_out;
logic walk_right_out;
logic aaah_out;
logic digging_out;

assign walk_left = walk_left_out;
assign walk_right = walk_right_out;
assign aaah = aaah_out;
assign digging = digging_out;

always_comb begin
    // Initialize the output signals
    walk_left_out = 0;
    walk_right_out = 0;
    aaah_out = 0;
    digging_out = 0;

    // Determine the next state
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_LEFT;
            end
            walk_left_out = 1;
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_RIGHT;
            end
            walk_right_out = 1;
        end
        FALLING: begin
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    // If the Lemming was walking left before falling, it will walk left again
                    // If the Lemming was walking right before falling, it will walk right again
                    // If the Lemming was digging before falling, it will walk in the original direction
                    if (state == DIGGING) begin
                        if (walk_left_out == 1) begin
                            next_state = IDLE_LEFT;
                        end else begin
                            next_state = IDLE_RIGHT;
                        end
                    end else begin
                        next_state = state;
                    end
                end
            end else begin
                next_state = FALLING;
            end
            aaah_out = 1;
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
            digging_out = 1;
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
        default: begin
            next_state = IDLE_LEFT;
        end
    endcase
end

always_ff @(posedge clk or posedge areset) begin
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

endmodule