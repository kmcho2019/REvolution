module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling
reg [1:0] nextState;

always @(*) begin
    case (state)
        0: begin // walking left
            if (bump_left) begin
                nextState = 1; // walking right
            end else if (bump_right) begin
                nextState = 1; // walking right
            end else if (!ground) begin
                nextState = 2; // falling
            end else begin
                nextState = 0; // stay walking left
            end
        end
        1: begin // walking right
            if (bump_right) begin
                nextState = 0; // walking left
            end else if (bump_left) begin
                nextState = 0; // walking left
            end else if (!ground) begin
                nextState = 2; // falling
            end else begin
                nextState = 1; // stay walking right
            end
        end
        2: begin // falling
            if (ground) begin
                if (bump_left || bump_right) begin
                    if (state == 0) begin
                        nextState = 1; // walking right
                    end else begin
                        nextState = 0; // walking left
                    end
                end else if (state == 0) begin
                    nextState = 0; // walking left
                end else begin
                    nextState = 1; // walking right
                end
            end else begin
                nextState = 2; // stay falling
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking left
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        0: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        1: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        2: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
    endcase
end

endmodule