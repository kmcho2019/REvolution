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

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling left)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        case(state)
            2'b00: // walking left
                begin
                    if (~ground) begin
                        state <= 2'b10; // falling left
                    end else if (bump_left) begin
                        state <= 2'b01; // walking right
                    end else if (bump_right) begin
                        // do nothing, keep walking left
                    end
                end
            2'b01: // walking right
                begin
                    if (~ground) begin
                        state <= 2'b10; // falling left (will be corrected to walking right when ground appears)
                    end else if (bump_right) begin
                        state <= 2'b00; // walking left
                    end else if (bump_left) begin
                        // do nothing, keep walking right
                    end
                end
            2'b10: // falling left
                begin
                    if (ground) begin
                        if (bump_left) begin
                            state <= 2'b01; // walking right
                        end else if (bump_right) begin
                            state <= 2'b00; // walking left
                        end else if (state == 2'b10) begin
                            state <= 2'b00; // walking left
                        end else begin
                            state <= 2'b01; // walking right
                        end
                    end
                end
        endcase
    end
end

assign walk_left = (state == 2'b00)? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01)? 1'b1 : 1'b0;
assign aaah = (state == 2'b10)? 1'b1 : 1'b0;

endmodule