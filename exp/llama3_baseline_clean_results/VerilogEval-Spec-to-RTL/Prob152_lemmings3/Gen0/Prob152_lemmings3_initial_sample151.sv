module TopModule (
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

// State encoding
parameter WALK_LEFT = 3'b001;
parameter WALK_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING_LEFT = 3'b100;
parameter DIGGING_RIGHT = 3'b101;

reg [2:0] state, next_state;

// Output logic
assign walk_left = (state == WALK_LEFT) || (state == DIGGING_LEFT);
assign walk_right = (state == WALK_RIGHT) || (state == DIGGING_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING_LEFT) || (state == DIGGING_RIGHT);

// Next state logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (next_state == WALK_LEFT || next_state == DIGGING_LEFT) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING_LEFT;
            end
        end
        DIGGING_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING_RIGHT;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule