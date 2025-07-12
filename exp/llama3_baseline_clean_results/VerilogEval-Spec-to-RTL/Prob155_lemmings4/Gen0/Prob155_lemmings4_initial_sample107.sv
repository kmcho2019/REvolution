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

// Define states
enum logic [2:0] {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Counter for falling clock cycles
logic [5:0] fall_counter;

// Set default values for outputs
assign walk_left = (state == IDLE_LEFT);
assign walk_right = (state == IDLE_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

// Combinational logic
always_comb begin
    next_state = state;
    case(state)
        IDLE_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left || (bump_right && bump_left)) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        IDLE_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_right || (bump_left && bump_right)) begin
                next_state = IDLE_LEFT;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else if (state == FALLING) begin
                    // Determine the previous state
                    if (dig) begin
                        next_state = IDLE_LEFT;
                    end else begin
                        next_state = IDLE_LEFT;
                    end
                end
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
end

endmodule