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
        if (carry) begin
            z <= ~x;
        end else begin
            z <= x;
        end
        carry <= carry | x;
    end
end

endmodule