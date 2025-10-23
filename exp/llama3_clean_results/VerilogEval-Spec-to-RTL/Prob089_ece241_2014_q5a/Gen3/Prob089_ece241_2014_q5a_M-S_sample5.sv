module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg sign;
reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        sign <= 1'b0;
        carry <= 1'b0;
    end else begin
        if (~sign) begin
            sign <= 1'b1;
            carry <= ~x;
            z <= ~x;
        end else begin
            z <= carry ^ ~x;
            carry <= carry & ~x | (~carry & x);
        end
    end
end

endmodule