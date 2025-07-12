module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg flag;  // Flag to indicate if we've seen the first '1'
reg carry;  // Carry to add 1 to the inverted input

always @(posedge clk or posedge areset) begin
    if (areset) begin
        flag <= 0;
        carry <= 0;
        z <= 0;
    end else begin
        if (~flag) begin
            if (x) begin
                flag <= 1;
                carry <= 1;
            end
            z <= ~x;
        end else begin
            z <= ~(x ^ carry);
            carry <= carry & ~x;
        end
    end
end

endmodule