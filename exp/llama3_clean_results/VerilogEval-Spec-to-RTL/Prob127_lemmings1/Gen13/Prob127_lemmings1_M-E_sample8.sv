module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [1:0] counter; // 2-bit counter

always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 0; // Reset counter to 0
    end else begin
        if (bump_left && !bump_right) begin
            counter <= counter + 1; // Increment counter if bumped from left
        end else if (!bump_left && bump_right) begin
            counter <= counter - 1; // Decrement counter if bumped from right
        end
    end
end

assign walk_left = counter[1]; // MSB determines direction
assign walk_right = ~counter[1];

endmodule