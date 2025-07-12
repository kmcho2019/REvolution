module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg invert;
reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        invert <= 0;
        carry <= 0;
        z <= 0;
    end else begin
        if (!invert) begin
            if (x) begin
                invert <= 1;
                z <= ~x;
                carry <= 1;
            end else begin
                z <= ~x;
            end
        end else begin
            z <= ~(x ^ carry);
            carry <= carry & ~x;
        end
    end
end

endmodule