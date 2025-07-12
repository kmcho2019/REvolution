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
    end else begin
        case (state)
            LEFT: state <= bump_left? RIGHT : LEFT;
            RIGHT: state <= bump_right? LEFT : RIGHT;
            default: state <= LEFT;
        endcase
        // Alternatively, for both bumps condition
        // if (bump_left && bump_right) state <= ~state;
        // else if (state == LEFT) state <= bump_left? RIGHT : LEFT;
        // else state <= bump_right? LEFT : RIGHT;
    end
end

always_comb begin
    case (state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    endcase
end

endmodule