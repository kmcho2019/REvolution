module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left <= 1;
        walk_right <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (bump_left) begin
                    walk_left <= 0;
                    walk_right <= 1;
                    state <= 1;
                end
            end
            1: begin // walking right
                if (bump_right) begin
                    walk_left <= 1;
                    walk_right <= 0;
                    state <= 0;
                end
            end
            default: begin
                walk_left <= 0;
                walk_right <= 0;
                state <= 0;
            end
        endcase
        // handle both bumps at the same time
        if (bump_left && bump_right) begin
            case (state)
                0: begin
                    walk_left <= 0;
                    walk_right <= 1;
                    state <= 1;
                end
                1: begin
                    walk_left <= 1;
                    walk_right <= 0;
                    state <= 0;
                end
                default: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    state <= 0;
                end
            endcase
        end
    end
end

endmodule