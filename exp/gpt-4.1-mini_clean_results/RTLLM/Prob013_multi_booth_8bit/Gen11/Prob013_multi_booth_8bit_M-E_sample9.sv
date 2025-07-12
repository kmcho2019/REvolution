module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,     // multiplicand
    input      [7:0]  b,     // multiplier
    output reg [15:0] p,     // product output
    output reg        rdy     // ready signal
);

    // Extended width for safe signed operations
    reg signed [8:0] multiplicand_ext;  // 9-bit signed multiplicand
    reg       [9:0] multiplier_ext;     // 10-bit multiplier with prepended zero for Booth recode

    reg [2:0] booth_bits;                // Current 3 bits for Booth encoding
    reg signed [17:0] partial_product;  // Partial product (max 2 * 9 bits = 18 bits)
    reg signed [31:0] product_accum;    // Accumulator with enough bits for sum
    reg [2:0] cycle;                    // 3-bit cycle counter (0..3)

    // Booth decode function
    // Input: 3 bits representing the booth recode segment
    // Output: multiplicand multiple: -2, -1, 0, +1, +2
    function signed [17:0] booth_decode;
        input [2:0] bits;
        reg signed [17:0] mcand_2;
        begin
            // multiplicand * 2 for quick use
            mcand_2 = multiplicand_ext <<< 1;
            case (bits)
                3'b000,
                3'b111: booth_decode = 18'sd0;
                3'b001,
                3'b010: booth_decode = multiplicand_ext;
                3'b011: booth_decode = mcand_2;
                3'b100: booth_decode = -mcand_2;
                3'b101,
                3'b110: booth_decode = -multiplicand_ext;
                default: booth_decode = 18'sd0; // should not occur
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // sign-extend multiplicand to 9 bits
            multiplicand_ext <= {a[7], a};
            // Extend multiplier by adding one zero bit LSB for Booth recoding
            multiplier_ext <= {b, 1'b0}; // 9+1 =10 bits
            product_accum <= 32'sd0;
            cycle <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (cycle < 3'd4) begin
                // Extract 3 bits for Booth code: bits 2*i+1 down to 2*i-1 for each cycle i
                // Positions: cycle*2+1 down to cycle*2 -1
                // Because multiplier_ext is 10 bits, indexing safe
                // Handle the case when (cycle*2 -1) == -1 for first cycle; treat as zero
                integer idx;
                idx = cycle * 2;

                // Extract bits with zero padding for negative index
                booth_bits[2] = multiplier_ext[idx + 1];    // bit at pos idx+1
                booth_bits[1] = multiplier_ext[idx];        // bit at pos idx
                booth_bits[0] = (idx == 0) ? 1'b0 : multiplier_ext[idx - 1]; // bit at pos idx-1 or zero

                // Compute partial product for this booth code
                partial_product = booth_decode(booth_bits);

                // Shift partial product by 2*cycle bits (radix-4)
                partial_product = partial_product <<< (cycle * 2);

                // Accumulate partial product
                product_accum <= product_accum + {{14{partial_product[17]}}, partial_product}; 
                // partial_product sign-extended from 18 bits to 32 bits (32-18=14 bits)

                cycle <= cycle + 1'b1;
            end else begin
                // Multiplication complete
                p <= product_accum[15:0]; // lower 16 bits are final product
                rdy <= 1'b1;
            end
        end
    end
endmodule