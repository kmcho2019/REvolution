module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state; // 0: walking left, 1: walking right
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        0: begin // walking left
            if (bump_left) begin
                next_state <= 1; // switch to walking right
            end else begin
                next_state <= 0; // stay walking left
            end
        end
        1: begin // walking right
            if (bump_right) begin
                next_state <= 0; // switch to walking left
            end else begin
                next_state <= 1; // stay walking right
            end
        end
        default: next_state <= 0; // default to walking left
    endcase

    // handle the case where both bump_left and bump_right are 1
    if (bump_left && bump_right) begin
        case (state)
            0: next_state <= 1; // switch to walking right
            1: next_state <= 0; // switch to walking left
            default: next_state <= 0; // default to walking left
        endcase
    end
end

assign walk_left = (state == 0); // walking left
assign walk_right = (state == 1); // walking right

endmodule