module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg first_one_seen;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        first_one_seen <= 0;
        z <= 0; // Reset output on areset
    end else begin
        if (~first_one_seen && x) begin
            first_one_seen <= 1;
            z <= 1; // Start inversion from the first '1'
        end else if (first_one_seen) begin
            z <= ~x; // Invert bits after the first '1'
        end
    end
end

endmodule