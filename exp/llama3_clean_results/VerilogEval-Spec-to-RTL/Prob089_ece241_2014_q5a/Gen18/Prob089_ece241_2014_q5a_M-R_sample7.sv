module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg carry;
assign z = x ^ carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        carry <= 1'b0;
    end else begin
        carry <= carry | x;
    end
end

endmodule