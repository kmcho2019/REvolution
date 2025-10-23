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
        // Simplify carry update logic to reduce switching activity
        carry <= (carry | x) & ~areset;
        // Maintain the simplified expression for z to minimize switching activity
        z <= x ^ carry;
    end
end

endmodule