module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Partial product for multiplication: since B is 8-bit and quotient 16-bit,
    // maximum product is 24-bit wide (16+8).
    reg [23:0] prod_candidate;
    reg [23:0] prod_current;
    reg [15:0] quotient_candidate;

    integer i;

    always @(*) begin
        a_reg = A;
        b_reg = B;

        quotient_candidate = 16'b0;
        prod_current = 24'b0;

        // Iteratively determine quotient bits from MSB to LSB
        // This is a binary search approach checking each bit of quotient
        for (i = 15; i >= 0; i = i - 1) begin
            // Tentatively set bit i
            quotient_candidate[i] = 1'b1;

            // Compute product = b_reg * quotient_candidate
            // Multiplication done via shifts and adds
            // Since quotient_candidate changes in each iteration,
            // recompute product entirely.

            // Clear product
            prod_candidate = 24'b0;

            // Multiply b_reg by quotient_candidate
            // Iterate over quotient_candidate bits
            integer j;
            for (j = 0; j < 16; j = j + 1) begin
                if (quotient_candidate[j]) begin
                    // Add (b_reg << j) to product
                    prod_candidate = prod_candidate + ({16'd0, b_reg} << j);
                end
            end

            // Check if product_candidate <= dividend (a_reg extended to 24 bits)
            if (prod_candidate <= {8'd0, a_reg}) begin
                // Accept the bit and current product
                prod_current = prod_candidate;
            end else begin
                // Reject the bit
                quotient_candidate[i] = 1'b0;
            end
        end

        result = quotient_candidate;

        // Compute remainder = dividend - (b_reg * quotient)
        // Use the final prod_current from above if accepted
        // Otherwise compute again (in case of rounding)
        // To be safe, compute subtraction here:
        reg [23:0] dividend_24;
        dividend_24 = {8'd0, a_reg};
        if (prod_current <= dividend_24) begin
            odd = dividend_24 - prod_current;
        end else begin
            // Recalculate product for final quotient
            reg [23:0] final_product;
            final_product = 24'b0;
            for (i = 0; i < 16; i = i + 1) begin
                if (quotient_candidate[i]) begin
                    final_product = final_product + ({16'd0, b_reg} << i);
                end
            end
            odd = dividend_24 - final_product;
        end
    end

endmodule