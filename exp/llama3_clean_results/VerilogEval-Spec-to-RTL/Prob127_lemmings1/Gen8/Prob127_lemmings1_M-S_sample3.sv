module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

// Enumerate states
enum logic [0:0] {LEFT, RIGHT} state;

// Define sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        case (state)
            LEFT: begin
                if (bump_left) begin
                    state <= RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end
            end
            RIGHT: begin
                if (bump_right) begin
                    state <= LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            default: begin
                state <= LEFT;
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end
        endcase
    end
end

endmodule