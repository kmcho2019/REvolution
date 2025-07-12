module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding: one-hot
    localparam WALK_LEFT  = 3'b001;
    localparam WALK_RIGHT = 3'b010;
    localparam FALLING    = 3'b100;

    reg [2:0] state, next_state;
    reg       direction; // 0 = left, 1 = right, tracks direction while falling

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING; // start falling, keep direction
                end else if (bump_left | bump_right) begin
                    // bump either side flips direction to right
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING; // start falling, keep direction
                end else if (bump_left | bump_right) begin
                    // bump either side flips direction to left
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    // ground back, resume walking in saved direction
                    next_state = direction ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1'b0; // left
        end else begin
            state <= next_state;
            // update direction only when walking and direction changes
            if (next_state == WALK_LEFT)
                direction <= 1'b0;
            else if (next_state == WALK_RIGHT)
                direction <= 1'b1;
            // falling preserves direction
        end
    end

    // Outputs: one-hot encoding for states
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule