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

    // One-hot encoding of states
    localparam WALK_LEFT  = 4'b0001;
    localparam WALK_RIGHT = 4'b0010;
    localparam FALL_LEFT  = 4'b0100;
    localparam FALL_RIGHT = 4'b1000;

    reg [3:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    // ground lost, start falling left
                    next_state = FALL_LEFT;
                end else if (bump_left && bump_right) begin
                    // bump both -> flip direction to walk right
                    next_state = WALK_RIGHT;
                end else if (bump_left) begin
                    // bumped left -> walk right
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // bumped right -> walk left (stay)
                    next_state = WALK_LEFT;
                end else begin
                    // no change
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    // ground lost, start falling right
                    next_state = FALL_RIGHT;
                end else if (bump_left && bump_right) begin
                    // bump both -> flip direction to walk left
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    // bumped left -> walk right (stay)
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // bumped right -> walk left
                    next_state = WALK_LEFT;
                end else begin
                    // no change
                    next_state = WALK_RIGHT;
                end
            end

            FALL_LEFT: begin
                if (ground) begin
                    // ground returned, resume walking left
                    next_state = WALK_LEFT;
                end else begin
                    // continue falling left
                    next_state = FALL_LEFT;
                end
            end

            FALL_RIGHT: begin
                if (ground) begin
                    // ground returned, resume walking right
                    next_state = WALK_RIGHT;
                end else begin
                    // continue falling right
                    next_state = FALL_RIGHT;
                end
            end

            default: begin
                // should never happen, reset to WALK_LEFT
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Outputs are Moore type
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule