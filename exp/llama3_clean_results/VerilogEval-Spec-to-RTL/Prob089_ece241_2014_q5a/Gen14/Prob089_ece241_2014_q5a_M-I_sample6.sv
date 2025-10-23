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
    end else if (x) begin // Use conditional statement to minimize switching activity
        carry <= 1'b1; // If x is 1, set carry to 1
        z <= ~x; // Invert x for z
    end else begin
        z <= x ^ carry; // Maintain the original logic for x = 0
        carry <= carry; // No change in carry when x = 0
    end
end

endmodule