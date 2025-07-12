module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [1:0] state; // 2 bits to represent 4 states: walking left, walking right, falling, digging
reg [1:0] next_state;

// Define states
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

// Define outputs for each state
localparam WALK_LEFT_OUT = {1'b1, 1'b0, 1'b0, 1'b0}; // walk_left, walk_right, aaah, digging
localparam WALK_RIGHT_OUT = {1'b0, 1'b1, 1'b0, 1'b0};
localparam FALLING_OUT = {1'b0, 1'b0, 1'b1, 1'b0};
localparam DIGGING_OUT = {1'b0, 1'b0, 1'b0, 1'b1};

always @(*) begin
    case(state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // No change
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // No change
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                // Resume previous direction
                if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT; // Default to walking left
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        WALK_LEFT: begin
            {walk_left, walk_right, aaah, digging} = WALK_LEFT_OUT;
        end
        WALK_RIGHT: begin
            {walk_left, walk_right, aaah, digging} = WALK_RIGHT_OUT;
        end
        FALLING: begin
            {walk_left, walk_right, aaah, digging} = FALLING_OUT;
        end
        DIGGING: begin
            {walk_left, walk_right, aaah, digging} = DIGGING_OUT;
        end
        default: begin
            {walk_left, walk_right, aaah, digging} = WALK_LEFT_OUT;
        end
    endcase
end

endmodule