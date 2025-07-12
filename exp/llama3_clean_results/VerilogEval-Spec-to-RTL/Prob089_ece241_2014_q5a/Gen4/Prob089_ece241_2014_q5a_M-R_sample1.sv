module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg sign;
reg carry;

always @(posedge clk) begin
    if (~areset) begin
        if (~sign) begin
            sign <= 1'b1;
            carry <= ~x;
        end else begin
            carry <= carry & ~x | (~carry & x);
        end
    end
end

always @(posedge areset) begin
    sign <= 1'b0;
    carry <= 1'b0;
end

assign z = (~sign) ? ~x : (carry ^ ~x);

endmodule