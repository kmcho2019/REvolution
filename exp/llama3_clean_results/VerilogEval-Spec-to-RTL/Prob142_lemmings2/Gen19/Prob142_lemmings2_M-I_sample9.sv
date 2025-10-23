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

reg direction; // 1 bit to represent the direction (0: left, 1: right)
reg falling; // 1 bit to represent the falling state (0: not falling, 1: falling)

// Combinational logic to determine the next state
always @(*) begin
    if (!ground) begin
        falling = 1'b1; // falling
    end else if (ground && falling) begin
        falling = 1'b0; // not falling
    end else if ((bump_left &&!direction) || (bump_right && direction)) begin
        direction = ~direction; // change direction
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // reset to left
        falling <= 1'b0; // reset to not falling
    end else begin
        if (ground) begin
            direction <= (bump_left &&!direction) || (bump_right && direction) ? ~direction : direction;
        end
        falling <= !ground ? 1'b1 : (falling && !ground) ? 1'b1 : 1'b0;
    end
end

// Output logic
assign walk_left = (!direction &&!falling)? 1'b1 : 1'b0;
assign walk_right = (direction &&!falling)? 1'b1 : 1'b0;
assign aaah = falling? 1'b1 : 1'b0;

endmodule