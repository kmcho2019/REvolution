module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // Initialize state as 1-bit reg
parameter WALK_LEFT = 0, WALK_RIGHT = 1;

always @(*) begin
    case(state)
        WALK_LEFT: begin
            if (bump_left) begin
                walk_left <= 0;
                walk_right <= 1;
            end else begin
                walk_left <= 1;
                walk_right <= 0;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                walk_left <= 1;
                walk_right <= 0;
            end else begin
                walk_left <= 0;
                walk_right <= 1;
            end
        end
        default: begin
            walk_left <= 1;
            walk_right <= 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        if (bump_left && ~bump_right) begin
            state <= WALK_RIGHT;
        end else if (~bump_left && bump_right) begin
            state <= WALK_LEFT;
        end else if (bump_left && bump_right) begin
            case(state)
                WALK_LEFT: state <= WALK_RIGHT;
                WALK_RIGHT: state <= WALK_LEFT;
            endcase
        end
    end
end

endmodule