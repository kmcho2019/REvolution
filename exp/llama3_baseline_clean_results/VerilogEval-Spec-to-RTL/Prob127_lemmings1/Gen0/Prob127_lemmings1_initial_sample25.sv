module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [0:0] state; // state variable, 0: walk left, 1: walk right

always @(posedge clk or posedge areset) begin
    if (areset) begin // asynchronous reset
        state <= 0; // reset to walk left state
    end else begin
        case (state)
            0: begin // walking left
                if (bump_left) begin
                    state <= 1; // switch to walking right
                end
            end
            1: begin // walking right
                if (bump_right) begin
                    state <= 0; // switch to walking left
                end
            end
            default: state <= 0; // default to walk left state
        endcase

        // handle the case where both bump_left and bump_right are 1
        if (bump_left && bump_right) begin
            case (state)
                0: state <= 1; // switch to walking right
                1: state <= 0; // switch to walking left
                default: state <= 0; // default to walk left state
            endcase
        end
    end
end

always @(*) begin
    case (state)
        0: begin // walking left
            walk_left = 1;
            walk_right = 0;
        end
        1: begin // walking right
            walk_left = 0;
            walk_right = 1;
        end
        default: begin // default to walk left state
            walk_left = 1;
            walk_right = 0;
        end
    endcase
end

endmodule