module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_one;  // Flag indicating we've seen the first '1'
    reg [7:0] shift_reg;  // Small buffer for timing optimization

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
            shift_reg <= 8'b0;
            z <= 1'b0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[6:0], x};
            
            // Update flag when first '1' is seen
            if (!seen_one && x) begin
                seen_one <= 1'b1;
            end
            
            // Output logic
            if (seen_one) begin
                z <= ~x;  // Invert after first '1'
            end else begin
                z <= x;  // Copy before first '1'
            end
        end
    end

endmodule