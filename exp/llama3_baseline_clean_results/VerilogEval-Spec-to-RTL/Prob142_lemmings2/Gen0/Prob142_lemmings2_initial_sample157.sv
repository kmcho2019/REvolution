module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 0; // Reset to walking left
    end else if (ground == 0) begin // Ground is gone, falling
        state <= 2;
    end else if (state == 2) begin // Falling, waiting for ground to appear
        state <= state; // Stay in falling state
    end else if (bump_left == 1 || bump_right == 1) begin // Bumped, switch direction
        if (state == 0) begin // Walking left, switch to walking right
            state <= 1;
        end else begin // Walking right, switch to walking left
            state <= 0;
        end
    end else begin // No bump, stay in current state
        state <= state;
    end
end

always @(*) begin
    case (state)
        0: begin // Walking left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        1: begin // Walking right
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        2: begin // Falling
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