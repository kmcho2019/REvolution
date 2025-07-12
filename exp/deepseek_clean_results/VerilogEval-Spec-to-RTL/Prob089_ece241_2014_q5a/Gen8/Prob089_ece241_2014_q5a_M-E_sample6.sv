module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg seen_one;
    reg [7:0] shift_reg;  // Using 8-bit for potential extension
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
            shift_reg <= 8'b0;
        end else begin
            // Shift in new bit
            shift_reg <= {x, shift_reg[7:1]};
            
            // Set flag when first '1' is seen
            if (!seen_one && x)
                seen_one <= 1'b1;
        end
    end

    // Output is original bit until first '1', then inverted
    assign z = seen_one ? ~shift_reg[0] : shift_reg[0];

endmodule