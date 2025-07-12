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
        // Simplified logic to minimize switching activity
        // The carry is only updated when x is 1, reducing unnecessary changes
        carry <= (x == 1'b1) ? 1'b1 : (carry & ~x);
        // The output z is the XOR of x and carry, which is the essence of 2's complement
        z <= x ^ carry;
    end
end

endmodule