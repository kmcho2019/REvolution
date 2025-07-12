module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [1:0] counter; // 2-bit counter to handle wrap-around

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 2'b00; // Reset counter
        walk_left <= 1'b1; // Initial direction: LEFT
        walk_right <= 1'b0;
    end else begin
        if (bump_left && bump_right) begin
            // If bumped from both sides, switch direction
            counter <= ~counter[0];
        end else if (bump_left) begin
            // If bumped from the left, switch to RIGHT
            counter <= 2'b01;
        end else if (bump_right) begin
            // If bumped from the right, switch to LEFT
            counter <= 2'b00;
        end
    end
end

always_comb begin
    case (counter[0])
        1'b0: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        1'b1: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule