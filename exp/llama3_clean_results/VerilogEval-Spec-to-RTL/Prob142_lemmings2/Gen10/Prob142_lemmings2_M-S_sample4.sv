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

reg walking_left;
reg next_walking_left;

// Combinational logic to determine the next walking direction
always @(*) begin
    next_walking_left = walking_left;

    if (~ground) begin
        // do nothing, keep the previous walking direction
    end else if (bump_left && walking_left) begin
        next_walking_left = 1'b0;
    end else if (bump_right && ~walking_left) begin
        next_walking_left = 1'b1;
    end else if (bump_left && ~walking_left) begin
        next_walking_left = 1'b1;
    end else if (bump_right && walking_left) begin
        next_walking_left = 1'b0;
    end
end

// Sequential logic to update the walking direction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_left <= 1'b1; // reset to walking left
    end else begin
        walking_left <= next_walking_left;
    end
end

// Output logic
assign walk_left = walking_left && ground;
assign walk_right = ~walking_left && ground;
assign aaah = ~ground;

endmodule