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

reg mode; // 1 bit to represent the mode (0: walking, 1: falling)
reg direction; // 1 bit to represent the direction (0: left, 1: right)

// Sequential logic to update the mode
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= 1'b0; // reset to walking mode
    end else begin
        if (~ground) begin
            mode <= 1'b1; // falling mode
        end else begin
            mode <= 1'b0; // walking mode
        end
    end
end

// Sequential logic to update the direction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // reset to left direction
    end else begin
        if (ground && bump_left) begin
            direction <= 1'b1; // right direction
        end else if (ground && bump_right) begin
            direction <= 1'b0; // left direction
        end
    end
end

// Output logic
assign walk_left = ~mode && ~direction;
assign walk_right = ~mode && direction;
assign aaah = mode;

endmodule