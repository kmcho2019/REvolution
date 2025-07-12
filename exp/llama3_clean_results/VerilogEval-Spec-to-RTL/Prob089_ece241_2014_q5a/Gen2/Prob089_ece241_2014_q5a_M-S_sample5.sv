module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg seen_one;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        seen_one <= 1'b0;
        z <= 1'b0;
    end else begin
        if (~seen_one && x) begin
            seen_one <= 1'b1;
            z <= ~x;
        end else if (seen_one) begin
            z <= ~(x ^ 1'b1); // Invert input considering carry
        end else begin
            z <= x; // Simply pass through input if no '1' seen
        end
    end
end

endmodule