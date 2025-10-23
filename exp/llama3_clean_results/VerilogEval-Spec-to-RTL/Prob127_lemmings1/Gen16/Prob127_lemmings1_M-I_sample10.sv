module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

localparam LEFT = 1'b0;
localparam RIGHT = 1'b1;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        case (state)
            LEFT: if (bump_left) begin
                state <= RIGHT;
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            RIGHT: if (bump_right) begin
                state <= LEFT;
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
            default: state <= LEFT;
        endcase
    end
end

endmodule