module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Define the states
parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;
parameter FALLING = 2'b10;

reg [1:0] state;
reg [1:0] next_state;
reg prev_walk_dir;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        prev_walk_dir <= 0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE_LEFT: begin
            if (ground == 0) begin
                next_state = FALLING;
            end else if (bump_left == 1 && bump_right == 1) begin
                next_state = IDLE_RIGHT;
            end else if (bump_left == 1) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right == 1) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (ground == 0) begin
                next_state = FALLING;
            end else if (bump_left == 1 && bump_right == 1) begin
                next_state = IDLE_LEFT;
            end else if (bump_right == 1) begin
                next_state = IDLE_LEFT;
            end else if (bump_left == 1) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground == 1) begin
                if (prev_walk_dir == 0) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

always @(posedge clk) begin
    if (state == IDLE_LEFT) begin
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        prev_walk_dir <= 0;
    end else if (state == IDLE_RIGHT) begin
        walk_left <= 0;
        walk_right <= 1;
        aaah <= 0;
        prev_walk_dir <= 1;
    end else if (state == FALLING) begin
        walk_left <= 0;
        walk_right <= 0;
        aaah <= 1;
    end
end

endmodule