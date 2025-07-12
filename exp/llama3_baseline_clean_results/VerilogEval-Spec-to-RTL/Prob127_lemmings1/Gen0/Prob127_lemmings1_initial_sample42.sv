module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // current state (0: walking left, 1: walking right)
reg [0:0] next_state; // next state

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Next state logic
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
        default: begin
            next_state <= 0; // default to walking left
        end
    endcase
    // if bumped on both sides, switch direction
    if (bump_left && bump_right) begin
        next_state <= ~state;
    end
end

// Output logic
always @(*) begin
    case (state)
        0: begin // walking left
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end
        1: begin // walking right
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end
        default: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end
    endcase
end

endmodule