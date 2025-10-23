module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
enum logic [1:0] {IDLE, WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state, next_state;

// Assign initial state
initial state = IDLE;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE; // Reset to IDLE state
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        IDLE: begin
            walk_left = 1'b1;
            if (bump_left || bump_right) begin
                next_state = WALK_RIGHT;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end
        end
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (bump_left || bump_right) begin
                next_state = WALK_RIGHT;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
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

endmodule