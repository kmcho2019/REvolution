module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg started;
reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        started <= 1'b0;
        carry <= 1'b0;
        z <= 1'b0;
    end else if (!started) begin
        started <= 1'b1;
        carry <= 1'b1;
        z <= ~x;
    end else begin
        z <= x ^ carry;
        carry <= carry;
    end
end

endmodule