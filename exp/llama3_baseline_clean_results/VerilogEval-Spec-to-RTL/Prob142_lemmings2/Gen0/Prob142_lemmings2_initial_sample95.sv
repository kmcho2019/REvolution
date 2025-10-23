module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // 2'b00: falling, 2'b01: walking left, 2'b10: walking right
reg prev_walk_direction; // 1: walking left, 0: walking right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to walking left
        prev_walk_direction <= 1'b1; // reset to walking left
    end else if (ground == 1'b1) begin
        case (state)
            2'b00: ; // stay in falling state if ground is 1 and we were falling
            2'b01: begin
                if (bump_left == 1'b1) begin
                    state <= 2'b10; // switch to walking right
                end
                if (bump_right == 1'b0 && bump_left == 1'b0) begin
                    state <= 2'b01; // stay walking left
                end
            end
            2'b10: begin
                if (bump_right == 1'b1) begin
                    state <= 2'b01; // switch to walking left
                end
                if (bump_right == 1'b0 && bump_left == 1'b0) begin
                    state <= 2'b10; // stay walking right
                end
            end
        endcase
    end else begin // ground is 0
        if (state == 2'b00) begin
            state <= 2'b00; // stay in falling state
        end else begin
            state <= 2'b00; // enter falling state
            prev_walk_direction <= (state == 2'b01)? 1'b1 : 1'b0; // store previous walking direction
        end
    end
end

always @(*) begin
    case (state)
        2'b00: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end
        2'b01: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end
        2'b10: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
        end
    endcase
end

endmodule