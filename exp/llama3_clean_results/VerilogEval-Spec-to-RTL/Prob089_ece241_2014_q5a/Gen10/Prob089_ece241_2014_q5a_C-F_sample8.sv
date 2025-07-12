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
        z <= x ^ carry;
        carry <= (x & ~carry) | (x & carry);
    end
end

endmodule