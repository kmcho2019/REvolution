module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        carry <= 1'b1;
    end else begin
        z <= ~x ^ carry;
        carry <= carry & ~x;
    end
end

endmodule