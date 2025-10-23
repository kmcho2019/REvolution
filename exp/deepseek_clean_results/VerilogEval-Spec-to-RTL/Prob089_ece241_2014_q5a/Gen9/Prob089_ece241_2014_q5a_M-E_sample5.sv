module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [31:0] shift_reg;  // Buffer for input bits
    reg found_one;         // Flag indicating first '1' found
    integer i;             // Loop variable for inversion

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 32'b0;
            found_one <= 1'b0;
        end else begin
            // Shift in new bit
            shift_reg <= {x, shift_reg[31:1]};
            
            // Set flag when first '1' is encountered
            if (x && !found_one) begin
                found_one <= 1'b1;
            end
        end
    end

    // Output logic: invert bits after first '1'
    assign z = found_one ? ~shift_reg[0] : shift_reg[0];

endmodule