module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] next_state;

parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL = 2'b10;

always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (ground == 0) begin
                next_state = FALL;
            end
            else if (bump_left == 1 && bump_right == 0) begin
                next_state = WALK_RIGHT;
            end
            else if (bump_left == 0 && bump_right == 1) begin
                next_state = WALK_LEFT;
            end
            else if (bump_left == 1 && bump_right == 1) begin
                next_state = WALK_RIGHT;
            end
            else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (ground == 0) begin
                next_state = FALL;
            end
            else if (bump_left == 1 && bump_right == 0) begin
                next_state = WALK_LEFT;
            end
            else if (bump_left == 0 && bump_right == 1) begin
                next_state = WALK_LEFT;
            end
            else if (bump_left == 1 && bump_right == 1) begin
                next_state = WALK_LEFT;
            end
            else begin
                next_state = WALK_RIGHT;
            end
        end
        FALL: begin
            if (ground == 1) begin
                next_state = state;
            end
            else begin
                next_state = FALL;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset == 1) begin
        state <= WALK_LEFT;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALL: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule