module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        carry <= 0;
    end else begin
        z <= x ^ carry;
        carry <= x | carry;
    end
end

endmodule