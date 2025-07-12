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

// Direction Controller
reg [1:0] direction; // 0: left, 1: right
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 2'b00; // reset to walking left
    end else if (bump_left && !bump_right) begin
        direction <= 2'b01; // switch to walking right
    end else if (!bump_left && bump_right) begin
        direction <= 2'b00; // switch to walking left
    end else if (bump_left && bump_right) begin
        direction <= ~direction; // switch direction
    end
end

// Fall Controller
reg falling;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        falling <= 1'b0; // reset to not falling
    end else if (!ground && !falling) begin
        falling <= 1'b1; // start falling
    end else if (ground && falling) begin
        falling <= 1'b0; // stop falling
    end
end

// Output Multiplexer
assign walk_left = (!falling && (direction == 2'b00));
assign walk_right = (!falling && (direction == 2'b01));
assign aaah = falling;

endmodule