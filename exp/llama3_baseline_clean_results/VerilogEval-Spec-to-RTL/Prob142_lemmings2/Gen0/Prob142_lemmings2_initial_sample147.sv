module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 0: walking_left, 1: walking_right, 2: falling
reg prev_walk; // store previous walking direction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
        prev_walk <= 1; // previous walk direction is left
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (~ground) begin
                    state <= 2; // start falling
                    prev_walk <= 1; // store previous walk direction
                end else if (bump_left) begin
                    state <= 1; // switch to walking right
                end
            end
            1: begin // walking right
                if (~ground) begin
                    state <= 2; // start falling
                    prev_walk <= 0; // store previous walk direction
                end else if (bump_right) begin
                    state <= 0; // switch to walking left
                end
            end
            2: begin // falling
                if (ground) begin
                    if (prev_walk) begin
                        state <= 0; // resume walking left
                    end else begin
                        state <= 1; // resume walking right
                    end
                end
            end
            default: state <= 0;
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // walking left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        1: begin // walking right
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        2: begin // falling
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
        end
    endcase
end

endmodule