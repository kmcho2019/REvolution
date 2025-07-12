module TopModule (
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
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;

reg [1:0] current_state;
reg [1:0] next_state;
reg walk_dir;

always @(*) begin
    // Next state logic
    case (current_state)
        WALK_LEFT: begin
            if (~ground) next_state = FALLING;
            else if (bump_left) next_state = WALK_RIGHT;
            else if (bump_right) next_state = WALK_LEFT;
            else next_state = WALK_LEFT;
            if (bump_left & bump_right) next_state = WALK_RIGHT;
        end
        WALK_RIGHT: begin
            if (~ground) next_state = FALLING;
            else if (bump_left) next_state = WALK_LEFT;
            else if (bump_right) next_state = WALK_LEFT;
            else next_state = WALK_RIGHT;
            if (bump_left & bump_right) next_state = WALK_LEFT;
        end
        FALLING: begin
            if (ground) begin
                if (walk_dir) next_state = WALK_LEFT;
                else next_state = WALK_RIGHT;
            end else next_state = FALLING;
        end
        default: next_state = WALK_LEFT;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
        walk_dir <= 1'b1;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == WALK_LEFT) begin
            walk_dir <= 1'b1;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end else if (current_state == WALK_RIGHT) begin
            walk_dir <= 1'b0;
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end else if (current_state == FALLING) begin
            aaah <= 1'b1;
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end
        if (~ground) aaah <= 1'b1;
        else aaah <= 1'b0;
    end
end

endmodule