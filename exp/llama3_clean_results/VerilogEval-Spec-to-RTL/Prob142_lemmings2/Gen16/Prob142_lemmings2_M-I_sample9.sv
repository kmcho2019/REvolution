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

reg direction; // 1-bit register to represent the direction (left or right)
reg falling; // 1-bit register to indicate whether the Lemming is falling or walking

// Combinational logic to determine the next state and output
always @(*) begin
    walk_left = direction && !falling;
    walk_right = !direction && !falling;
    aaah = falling;

    if (~ground) begin
        falling = 1'b1;
    end else if (ground && falling) begin
        falling = 1'b0;
    end else if ((bump_left && direction) || (bump_right && !direction)) begin
        direction = ~direction;
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // reset to walking left
        falling <= 1'b0;
    end else begin
        direction <= direction;
        falling <= falling;
    end
end

endmodule