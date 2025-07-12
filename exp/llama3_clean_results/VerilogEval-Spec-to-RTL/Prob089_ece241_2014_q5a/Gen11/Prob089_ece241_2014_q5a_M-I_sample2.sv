module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        carry <= 1'b0;
        z <= 1'b0;
    end else begin
        // The expression for z remains the same, as it directly implements the 2's complement logic
        z <= x ^ carry;
        // The carry update logic can be slightly optimized by recognizing that carry will only be 1 after the first bit is received and then it stays 1 as long as x is 1
        carry <= (x == 1'b1) ? 1'b1 : (carry & ~x);
    end
end

endmodule