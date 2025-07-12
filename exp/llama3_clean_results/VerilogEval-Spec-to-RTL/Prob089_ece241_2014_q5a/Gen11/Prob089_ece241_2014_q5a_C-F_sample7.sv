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
        if (~first_one_seen) begin
            if (x) begin
                first_one_seen <= 1'b1;
                z <= ~x; // Start of conversion
            end else begin
                z <= 1'b0; // Before first '1', output remains 0
            end
        end else begin
            z <= ~x; // Invert input bit
            carry <= carry | x; // Handle carry propagation
        end
    end
end

endmodule