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

reg [1:0] state; // 00: walking left, 01: walking right, 10: falling left, 11: falling right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
    end else begin
        case (state)
            2'b00: begin // walking left
                if (bump_left) begin
                    state <= 2'b01; // switch to walking right
                end else if (!ground) begin
                    state <= 2'b10; // start falling
                end
            end
            2'b01: begin // walking right
                if (bump_right) begin
                    state <= 2'b00; // switch to walking left
                end else if (!ground) begin
                    state <= 2'b11; // start falling
                end
            end
            2'b10: begin // falling left
                if (ground) begin
                    state <= 2'b00; // resume walking left
                end
            end
            2'b11: begin // falling right
                if (ground) begin
                    state <= 2'b01; // resume walking right
                end
            end
        endcase
    end
end

assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b10 || state == 2'b11);

endmodule