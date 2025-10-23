module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_one;  // Flag to track first '1' occurrence
    reg [7:0] shift_reg;  // Buffer for recent bits (size can be adjusted)

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
            if (!seen_one) begin
                z <= x;  // Copy mode
            end else begin
                z <= ~shift_reg[7];  // Invert oldest bit in buffer
            end
        end
    end

endmodule