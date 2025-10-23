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

// Define states
enum logic [1:0] {
    LEFT,
    RIGHT,
    FALL
} state, next_state;

// Register to store previous walking state
reg [1:0] prev_state;

always @(*) begin
    // Default outputs
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;

    case (state)
        LEFT: begin
            walk_left = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALL;
            end else if (bump_left == 1'b1 || (bump_left == 1'b0 && bump_right == 1'b1)) begin
                next_state = RIGHT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            walk_right = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALL;
            end else if (bump_right == 1'b1 || (bump_right == 1'b0 && bump_left == 1'b1)) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
            end
        end
        FALL: begin
            aaah = 1'b1;
            if (ground == 1'b1) begin
                next_state = prev_state;
            end else begin
                next_state = FALL;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
        prev_state <= LEFT;
    end else begin
        if (state == FALL && ground == 1'b1) begin
            state <= prev_state;
        end else if (state == LEFT && (bump_left == 1'b1 || (bump_left == 1'b0 && bump_right == 1'b1))) begin
            state <= RIGHT;
            prev_state <= LEFT;
        end else if (state == RIGHT && (bump_right == 1'b1 || (bump_right == 1'b0 && bump_left == 1'b1))) begin
            state <= LEFT;
            prev_state <= RIGHT;
        end else if (state == LEFT && ground == 1'b0) begin
            state <= FALL;
            prev_state <= LEFT;
        end else if (state == RIGHT && ground == 1'b0) begin
            state <= FALL;
            prev_state <= RIGHT;
        end else begin
            state <= next_state;
        end
    end
end

endmodule