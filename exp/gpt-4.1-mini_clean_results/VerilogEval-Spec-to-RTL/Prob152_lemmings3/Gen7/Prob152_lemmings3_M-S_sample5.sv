module TopModule(
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
localparam WALK_LEFT  = 3'd0;
localparam WALK_RIGHT = 3'd1;
localparam FALL_LEFT  = 3'd2;
localparam FALL_RIGHT = 3'd3;
localparam DIG_LEFT   = 3'd4;
localparam DIG_RIGHT  = 3'd5;

reg [2:0] state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    next_state = state; // default hold

    case (state)
        WALK_LEFT: begin
            if (ground == 1'b0) begin
                next_state = FALL_LEFT;        // fall overrides all
            end else if (dig == 1'b1) begin
                next_state = DIG_LEFT;         // dig if ground and dig=1
            end else if (bump_left || bump_right) begin
                // bumps switch direction; both bumps also switch direction
                next_state = WALK_RIGHT;
            end
        end

        WALK_RIGHT: begin
            if (ground == 1'b0) begin
                next_state = FALL_RIGHT;
            end else if (dig == 1'b1) begin
                next_state = DIG_RIGHT;
            end else if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
            end
        end

        FALL_LEFT: begin
            if (ground == 1'b1) begin
                next_state = WALK_LEFT; // resume walking same dir
            end
        end

        FALL_RIGHT: begin
            if (ground == 1'b1) begin
                next_state = WALK_RIGHT;
            end
        end

        DIG_LEFT: begin
            if (ground == 1'b0) begin
                next_state = FALL_LEFT; // fall when ground lost during digging
            end
        end

        DIG_RIGHT: begin
            if (ground == 1'b0) begin
                next_state = FALL_RIGHT;
            end
        end

        default: next_state = WALK_LEFT; // safe default
    endcase
end

assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
assign digging    = (state == DIG_LEFT)  || (state == DIG_RIGHT);

endmodule