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

reg [1:0] state; // 2'b00: walking left, 2'b01: walking right, 2'b10: falling
reg prev_walk; // previous walking direction (0: left, 1: right)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        prev_walk <= 0;
    end else begin
        case (state)
            2'b00: begin // walking left
                if (~ground) begin
                    state <= 2'b10; // start falling
                end else if (bump_left) begin
                    state <= 2'b01; // switch to walking right
                    prev_walk <= 1;
                end else if (bump_right) begin
                    state <= 2'b00; // continue walking left
                end
            end
            2'b01: begin // walking right
                if (~ground) begin
                    state <= 2'b10; // start falling
                end else if (bump_left) begin
                    state <= 2'b00; // switch to walking left
                    prev_walk <= 0;
                end else if (bump_right) begin
                    state <= 2'b00; // switch to walking left
                    prev_walk <= 0;
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    if (prev_walk) begin
                        state <= 2'b01; // resume walking right
                    end else begin
                        state <= 2'b00; // resume walking left
                    end
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule