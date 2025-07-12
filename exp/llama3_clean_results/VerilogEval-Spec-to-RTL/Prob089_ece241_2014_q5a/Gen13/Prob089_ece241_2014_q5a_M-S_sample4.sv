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
    end else begin
        z <= x ^ carry;
        if (x) carry <= 1'b1;
    end
end

endmodule