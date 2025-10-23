module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg [1:0] state; // 0: walking left, 1: walking right
    reg [1:0] next_state;

    localparam WALK_LEFT = 0;
    localparam WALK_RIGHT = 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT; // already in walk_left state, so stay in it
                end else begin
                    next_state = WALK_LEFT; // no bumps, stay in walk_left state
                end
            end
            WALK_RIGHT: begin
                if (bump_right) begin
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT; // already in walk_right state, so stay in it
                end else begin
                    next_state = WALK_RIGHT; // no bumps, stay in walk_right state
                end
            end
            default: begin
                next_state = WALK_LEFT; // default to walk_left state
            end
        endcase
    end

    // output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule