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

    // One-hot state encoding (4 bits)
    localparam WALK_LEFT  = 4'b0001;
    localparam WALK_RIGHT = 4'b0010;
    localparam FALL_LEFT  = 4'b0100;
    localparam FALL_RIGHT = 4'b1000;

    reg [3:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else if (bump_left && bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (bump_left && bump_right) begin
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALL_LEFT: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALL_LEFT;
                end
            end
            FALL_RIGHT: begin
                if (ground) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = FALL_RIGHT;
                end
            end
            default: next_state = WALK_LEFT; // Safety fallback
        endcase
    end

    // Sequential state register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore output decoding
    assign walk_left  = state == WALK_LEFT;
    assign walk_right = state == WALK_RIGHT;
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule