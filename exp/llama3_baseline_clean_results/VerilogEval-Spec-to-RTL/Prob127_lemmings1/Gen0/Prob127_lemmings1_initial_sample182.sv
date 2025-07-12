module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state; // 0: walking left, 1: walking right
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b00: begin // walking left
            if (bump_left) begin
                next_state = 2'b01; // switch to walking right
            end else begin
                next_state = 2'b00; // stay walking left
            end
        end
        2'b01: begin // walking right
            if (bump_right) begin
                next_state = 2'b00; // switch to walking left
            end else begin
                next_state = 2'b01; // stay walking right
            end
        end
        default: next_state = 2'b00; // default to walking left
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        if (bump_left && bump_right) begin
            state <= ~state; // switch directions if bumped on both sides
        end else begin
            state <= next_state;
        end
    end
end

always @(*) begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

endmodule