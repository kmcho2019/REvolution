module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state;
reg [1:0] nextState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking left state
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // Walking left state
            if (ground == 1'b0) begin
                nextState = 2'b10; // Transition to falling state
            end else if (bump_left == 1'b1) begin
                nextState = 2'b01; // Transition to walking right state
            end else begin
                nextState = 2'b00; // Stay in walking left state
            end
        end
        2'b01: begin // Walking right state
            if (ground == 1'b0) begin
                nextState = 2'b10; // Transition to falling state
            end else if (bump_right == 1'b1) begin
                nextState = 2'b00; // Transition to walking left state
            end else begin
                nextState = 2'b01; // Stay in walking right state
            end
        end
        2'b10: begin // Falling state
            if (ground == 1'b1) begin
                if (bump_left == 1'b1 && bump_right == 1'b1) begin
                    nextState = 2'b00; // Transition to walking left state
                end else if (bump_left == 1'b1) begin
                    nextState = 2'b01; // Transition to walking right state
                end else if (bump_right == 1'b1) begin
                    nextState = 2'b00; // Transition to walking left state
                end else if (state == 2'b00) begin
                    nextState = 2'b01; // Transition to walking right state
                end else begin
                    nextState = state; // Stay in the same state
                end
            end else begin
                nextState = 2'b10; // Stay in falling state
            end
        end
        default: begin
            nextState = 2'b00; // Transition to walking left state
        end
    endcase
end

always @(*) begin
    case (state)
        2'b00: begin // Walking left state
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // Walking right state
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // Falling state
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule