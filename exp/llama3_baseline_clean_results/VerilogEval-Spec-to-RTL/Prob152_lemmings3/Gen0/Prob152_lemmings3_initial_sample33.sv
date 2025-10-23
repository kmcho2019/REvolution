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

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

reg [1:0] state, next_state;
reg [1:0] prev_state;
reg prev_ground;

// Output assignments
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_state <= WALK_LEFT;
        prev_ground <= 1;
    end else begin
        state <= next_state;
        prev_state <= state;
        prev_ground <= ground;
    end
end

// Combinational logic
always @(*) begin
    next_state = state;

    case (state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end
        end

        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
        end

        FALLING: begin
            if (ground) begin
                next_state = prev_state;
            end
        end

        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
            end
        end

        default: next_state = WALK_LEFT;
    endcase

    if (bump_left && bump_right) begin
        if (state == WALK_LEFT) begin
            next_state = WALK_RIGHT;
        end else if (state == WALK_RIGHT) begin
            next_state = WALK_LEFT;
        end
    end
end

endmodule