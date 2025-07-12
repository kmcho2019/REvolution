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
        if (x) begin
            carry <= 1'b1;
        end
    end
end

assign z = x ? ~carry : carry;

endmodule