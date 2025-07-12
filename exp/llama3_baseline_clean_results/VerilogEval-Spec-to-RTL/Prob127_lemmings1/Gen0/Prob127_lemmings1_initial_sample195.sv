module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // Two-state encoding: 0 - walking left, 1 - walking right

localparam WALK_LEFT = 0;
localparam WALK_RIGHT = 1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        case(state)
            WALK_LEFT: begin
                if (bump_left) begin
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else begin
                    state <= state;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            WALK_RIGHT: begin
                if (bump_right) begin
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end else begin
                    state <= state;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end
            end
        endcase
    end
end

endmodule