module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [2:0] state; // 0: walking_left, 1: walking_right, 2: falling, 3: digging_left, 4: digging_right
reg [2:0] nextState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking_left state
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        0: begin // walking_left
            if (!ground) begin
                nextState = 2; // falling
            end else if (bump_left) begin
                nextState = 1; // walking_right
            end else if (dig) begin
                nextState = 3; // digging_left
            end else if (bump_right) begin
                nextState = 1; // walking_right
            end else begin
                nextState = 0; // stay in walking_left state
            end
        end
        1: begin // walking_right
            if (!ground) begin
                nextState = 2; // falling
            end else if (bump_right) begin
                nextState = 0; // walking_left
            end else if (dig) begin
                nextState = 4; // digging_right
            end else if (bump_left) begin
                nextState = 0; // walking_left
            end else begin
                nextState = 1; // stay in walking_right state
            end
        end
        2: begin // falling
            if (ground) begin
                if (dig) begin
                    nextState = state == 2 ? 0 : state - 3; // resume walking
                end else begin
                    nextState = state == 2 ? 0 : state - 3; // resume walking
                end
            end else begin
                nextState = 2; // stay in falling state
            end
        end
        3: begin // digging_left
            if (!ground) begin
                nextState = 2; // falling
            end else begin
                nextState = 3; // stay in digging_left state
            end
        end
        4: begin // digging_right
            if (!ground) begin
                nextState = 2; // falling
            end else begin
                nextState = 4; // stay in digging_right state
            end
        end
        default: begin
            nextState = 0; // default to walking_left state
        end
    endcase
end

always @(*) begin
    case (state)
        0: begin // walking_left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        1: begin // walking_right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        2: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        3: begin // digging_left
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        4: begin // digging_right
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule