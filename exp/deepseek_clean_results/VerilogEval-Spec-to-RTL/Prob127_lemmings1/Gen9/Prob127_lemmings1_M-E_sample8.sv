module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam LEFT = 2'b00;
    localparam TURNING_RIGHT = 2'b01;
    localparam RIGHT = 2'b10;
    localparam TURNING_LEFT = 2'b11;

    reg [1:0] state, next_state;
    reg bump_left_prev, bump_right_prev;

    // Edge detection for bump inputs
    wire bump_left_edge = bump_left & ~bump_left_prev;
    wire bump_right_edge = bump_right & ~bump_right_prev;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end else begin
            state <= next_state;
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (bump_left_edge)
                    next_state = TURNING_RIGHT;
                else
                    next_state = LEFT;
            end
            TURNING_RIGHT: next_state = RIGHT;
            RIGHT: begin
                if (bump_right_edge)
                    next_state = TURNING_LEFT;
                else
                    next_state = RIGHT;
            end
            TURNING_LEFT: next_state = LEFT;
            default: next_state = LEFT;
        endcase
    end

    // Output logic (Moore style)
    assign walk_left = (state == LEFT) || (state == TURNING_LEFT);
    assign walk_right = (state == RIGHT) || (state == TURNING_RIGHT);

endmodule