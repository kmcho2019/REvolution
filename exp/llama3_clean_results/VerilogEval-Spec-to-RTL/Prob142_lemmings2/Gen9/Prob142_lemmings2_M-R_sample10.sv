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

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling left, 11: falling right)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        if (~ground && (state == 2'b00 || state == 2'b01)) begin
            // if ground is lost, start falling
            state <= (state == 2'b00) ? 2'b10 : 2'b11;
        end else if (ground && (state == 2'b10 || state == 2'b11)) begin
            // if ground is regained, resume walking
            state <= (state == 2'b10) ? 2'b00 : 2'b01;
        end else if (bump_left && (state == 2'b00 || state == 2'b10)) begin
            // if bumped from the left, switch to walking right
            state <= 2'b01;
        end else if (bump_right && (state == 2'b01 || state == 2'b11)) begin
            // if bumped from the right, switch to walking left
            state <= 2'b00;
        end
    end
end

assign walk_left = (state == 2'b00) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01) ? 1'b1 : 1'b0;
assign aaah = (state == 2'b10 || state == 2'b11) ? 1'b1 : 1'b0;

endmodule