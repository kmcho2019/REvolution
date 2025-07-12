module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Define the states
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING} state, next_state;

// Initialize the state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

// State transitions
always @(*) begin
    case(state)
        IDLE_LEFT: begin
            if (bump_left) begin
                next_state <= IDLE_RIGHT;
            end else if (bump_right) begin
                next_state <= IDLE_LEFT;
            end else if (!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (bump_right) begin
                next_state <= IDLE_LEFT;
            end else if (bump_left) begin
                next_state <= IDLE_RIGHT;
            end else if (!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (state == IDLE_LEFT) begin
                    next_state <= IDLE_LEFT;
                end else if (state == IDLE_RIGHT) begin
                    next_state <= IDLE_RIGHT;
                end else begin
                    next_state <= IDLE_LEFT;
                end
            end else begin
                next_state <= FALLING;
            end
        end
        default: begin
            next_state <= IDLE_LEFT;
        end
    endcase
end

// Outputs
always @(*) begin
    case(state)
        IDLE_LEFT: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
        end
        IDLE_RIGHT: begin
            walk_left <= 0;
            walk_right <= 1;
            aaah <= 0;
        end
        FALLING: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
        end
        default: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
        end
    endcase
end

endmodule