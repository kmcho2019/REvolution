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

reg [1:0] state; // 2'b00: walking left, 2'b01: walking right, 2'b10: falling
reg prev_walk_left; // previous walking direction while falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        prev_walk_left <= 1'b1; // default previous walking direction to left
    end else begin
        case (state)
            2'b00: begin // walking left
                if (bump_left) begin
                    state <= 2'b01; // transition to walking right
                end else if (bump_right) begin
                    // do nothing, already walking left
                end else if (!ground) begin
                    state <= 2'b10; // transition to falling
                    prev_walk_left <= 1'b1; // save previous walking direction
                end
            end
            2'b01: begin // walking right
                if (bump_right) begin
                    state <= 2'b00; // transition to walking left
                end else if (bump_left) begin
                    // do nothing, already walking right
                end else if (!ground) begin
                    state <= 2'b10; // transition to falling
                    prev_walk_left <= 1'b0; // save previous walking direction
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    if (prev_walk_left) begin
                        state <= 2'b00; // transition to walking left
                    end else begin
                        state <= 2'b01; // transition to walking right
                    end
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule