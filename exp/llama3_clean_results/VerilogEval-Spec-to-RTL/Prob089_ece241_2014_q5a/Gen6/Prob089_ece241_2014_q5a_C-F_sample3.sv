module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg carry;
reg first_one_seen;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        carry <= 1'b0;
        first_one_seen <= 1'b0;
        z <= 1'b0;
    end else begin
        if (~first_one_seen && x) begin
            first_one_seen <= 1;
            carry <= 1;
            z <= 1;
        end else if (first_one_seen) begin
            z <= x ^ carry;
            carry <= carry | x;
        end else begin
            z <= 0;
            carry <= 0;
        end
    end
end

endmodule