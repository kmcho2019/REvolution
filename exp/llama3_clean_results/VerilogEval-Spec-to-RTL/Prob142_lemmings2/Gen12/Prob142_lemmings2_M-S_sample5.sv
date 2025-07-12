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

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        case(state)
            2'b00: // walking left
                begin
                    if (~ground) begin
                        state <= 2'b10; // falling
                    end else if (bump_left) begin
                        state <= 2'b01; // walking right
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end else if (bump_right) begin
                        // do nothing, keep walking left
                    end
                end
            2'b01: // walking right
                begin
                    if (~ground) begin
                        state <= 2'b10; // falling
                    end else if (bump_right) begin
                        state <= 2'b00; // walking left
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else if (bump_left) begin
                        // do nothing, keep walking right
                    end
                end
            2'b10: // falling
                begin
                    if (ground) begin
                        if (walk_left) begin
                            state <= 2'b00; // walking left
                        end else begin
                            state <= 2'b01; // walking right
                        end
                    end
                end
        endcase
        if (state == 2'b10) begin
            aaah <= 1'b1;
        end else begin
            aaah <= 1'b0;
        end
    end
end

endmodule