module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,     // multiplicand
    input      [7:0]   b,     // multiplier
    output reg [15:0]  p,     // product output
    output reg         rdy     // ready signal
);

    // Internal registers for signed arithmetic
    reg signed [31:0] product_reg;       // Partial product register (32 bits)
    reg signed [16:0] multiplicand_reg;  // Sign-extended multiplicand (17 bits)
    reg signed [16:0] multiplier_reg;    // Sign-extended multiplier with extra bit (17 bits)

    reg [2:0] count;  // 3-bit counter for 4 cycles

    // Radix-4 Booth decode function
    // Input: 3 bits from multiplier register
    // Output: Signed multiple of multiplicand (-2 to +2)
    function signed [18:0] booth_decode; 
        input [2:0] bits;
        reg signed [18:0] val;
        begin
            case (bits)
                3'b000,
                3'b111: val = 19'sd0;
                3'b001,
                3'b010: val = {{2{multiplicand_reg[16]}}, multiplicand_reg};       // +1 * multiplicand (19 bits)
                3'b011: val = {{2{multiplicand_reg[16]}}, multiplicand_reg} <<< 1; // +2 * multiplicand
                3'b100: val = -({{2{multiplicand_reg[16]}}, multiplicand_reg} <<< 1);// -2 * multiplicand
                3'b101,
                3'b110: val = -{{2{multiplicand_reg[16]}}, multiplicand_reg};      // -1 * multiplicand
                default: val = 19'sd0;
            endcase
            booth_decode = val;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // On reset, sign-extend inputs and initialize registers
            multiplicand_reg <= { {9{a[7]}}, a };   // 8 bits + 9 bits sign extension = 17 bits
            multiplier_reg   <= { {8{b[7]}}, b, 1'b0 }; // 8 bits + 8 bits sign ext + extra LSB 0 (17 bits)
            product_reg      <= 32'sd0;
            count            <= 3'd0;
            p                <= 16'd0;
            rdy              <= 1'b0;
        end else if (!rdy) begin
            if (count < 3'd4) begin
                // Extract the current 3 LSB bits from multiplier_reg for Booth encoding
                // These are bits [2:0] of multiplier_reg
                // Use booth_decode to get multiple of multiplicand to add
                product_reg <= product_reg + booth_decode(multiplier_reg[2:0]);

                // Shift arithmetic right combined {product_reg, multiplier_reg} by 2 bits
                // Combine 49-bit signed vector: {product_reg[31:0], multiplier_reg[16:0]}
                // Shift by 2 bits with sign extension of product_reg[31]
                {product_reg, multiplier_reg} <= {product_reg, multiplier_reg} >>> 2;

                count <= count + 1'b1;
            end else begin
                // Multiplication complete, output product and assert ready
                p <= product_reg[15:0];  // Lower 16 bits are the product
                rdy <= 1'b1;
            end
        end else begin
            // Once ready, maintain output stable until reset
            rdy <= 1'b1;
        end
    end

endmodule