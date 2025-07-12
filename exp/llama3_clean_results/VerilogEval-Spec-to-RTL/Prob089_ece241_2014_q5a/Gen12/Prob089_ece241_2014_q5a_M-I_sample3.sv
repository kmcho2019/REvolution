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
        // Simplify the carry update logic to reduce combinational depth and potential power consumption
        carry <= carry | x;
        // The expression for z remains the same, directly implementing the 2's complement logic
        z <= x ^ carry;
    end
end

endmodule