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
reg walk_dir; // 1 bit to represent the walking direction (0: left, 1: right)

// Combinational logic to determine the next state
always @(*) begin
    walk_dir = walk_dir;
    state = state;

    if (~ground) begin
        state = 2'b10; // falling
    end else if (ground && state == 2'b10) begin
        state = walk_dir ? 2'b01 : 2'b00; // walking
    end else if ((bump_left && walk_dir == 1'b0) || (bump_right && walk_dir == 1'b1)) begin
        walk_dir = ~walk_dir; // change direction
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        walk_dir <= 1'b0;
    end else begin
        state <= state;
        walk_dir <= walk_dir;
    end
end

// Output logic
assign walk_left = (state == 2'b00 || (state == 2'b10 && walk_dir == 1'b0)) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01 || (state == 2'b10 && walk_dir == 1'b1)) ? 1'b1 : 1'b0;
assign aaah = (state == 2'b10) ? 1'b1 : 1'b0;

endmodule