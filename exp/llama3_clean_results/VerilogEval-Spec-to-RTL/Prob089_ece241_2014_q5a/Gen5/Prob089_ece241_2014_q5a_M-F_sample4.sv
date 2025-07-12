module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg first_one_seen;
reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        first_one_seen <= 0;
        carry <= 0;
        z <= 0;
    end else begin
        if (~first_one_seen) begin
            if (x) begin
                first_one_seen <= 1;
                z <= 1; // Start of conversion
            end else begin
                z <= 0; // Before first '1', output remains 0
            end
        end else begin
            // Invert input bit
            z <= ~x;
            
            // Handle carry propagation
            if (carry) begin
                z <= z + 1; // Add 1 if carry is set
                carry <= 0; // Reset carry
            end
        end
    end
end

endmodule