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

reg [1:0] counter; // 2 bits to represent the counter (direction and state)

// Sequential logic to update the counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 2'b00; // reset to walking left
    end else begin
        if (~ground) begin
            counter[1] <= 1'b1; // set falling state
        end else if (ground && counter[1] == 1'b1) begin
            counter[1] <= 1'b0; // reset falling state
        end

        if (bump_left && counter[0] == 1'b0) begin
            counter[0] <= 1'b1; // change direction to right
        end else if (bump_right && counter[0] == 1'b1) begin
            counter[0] <= 1'b0; // change direction to left
        end
    end
end

// Output logic
assign walk_left = (counter[1] == 1'b0 && counter[0] == 1'b0) ? 1'b1 : 1'b0;
assign walk_right = (counter[1] == 1'b0 && counter[0] == 1'b1) ? 1'b1 : 1'b0;
assign aaah = (counter[1] == 1'b1) ? 1'b1 : 1'b0;

endmodule