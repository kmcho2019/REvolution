module TopModule (
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    input         ground,
    output        walk_left,
    output        walk_right,
    output        aaah
);

// Define states
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING} state, nextState;

// Define previous walking direction when falling
logic prev_walk_left, prev_walk_right;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_walk_left <= 1'b1;
        prev_walk_right <= 1'b0;
    end else begin
        state <= nextState;
        if (nextState == FALLING) begin
            prev_walk_left <= walk_left;
            prev_walk_right <= walk_right;
        end else if (state == FALLING && ground == 1'b1) begin
            prev_walk_left <= 1'b0;
            prev_walk_right <= 1'b0;
        end
    end
end

// Combinational logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (bump_left == 1'b1) begin
                nextState = WALK_RIGHT;
            end else if (ground == 1'b0) begin
                nextState = FALLING;
            end else begin
                nextState = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (bump_right == 1'b1) begin
                nextState = WALK_LEFT;
            end else if (ground == 1'b0) begin
                nextState = FALLING;
            end else begin
                nextState = WALK_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground == 1'b1) begin
                if (prev_walk_left == 1'b1) begin
                    nextState = WALK_LEFT;
                end else begin
                    nextState = WALK_RIGHT;
                end
            end else begin
                nextState = FALLING;
            end
        end
    endcase
end

endmodule