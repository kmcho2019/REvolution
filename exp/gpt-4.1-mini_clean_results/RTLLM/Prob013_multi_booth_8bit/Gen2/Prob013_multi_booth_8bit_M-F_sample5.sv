module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal signals
    reg signed [17:0] product;        // 18 bits to hold partial product with sign extension
    reg signed [15:0] multiplicand;   // sign-extended multiplicand
    reg [8:0] multiplier_ext;         // multiplier extended by one bit at LSB for Booth encoding
    reg [2:0] cycle;                  // counts 0 to 4 for 4 iterations (8 bits / 2 bits per cycle = 4 cycles)
    
    // Booth encoding function: takes 3 bits and returns a signed value multiplied by multiplicand
    // Encoding according to radix-4 Booth rules:
    // 000,111: 0
    // 001,010: +1 * multiplicand
    // 011: +2 * multiplicand
    // 100: -2 * multiplicand
    // 101,110: -1 * multiplicand
    // We'll implement as a combinational function
    function signed [17:0] booth_calc;
        input [2:0] bits;
        begin
            case(bits)
                3'b000,
                3'b111: booth_calc = 18'sd0;
                3'b001,
                3'b010: booth_calc = { {2{multiplicand[15]}}, multiplicand };            // +1 * multiplicand
                3'b011: booth_calc = { {2{multiplicand[15]}}, multiplicand } << 1;     // +2 * multiplicand
                3'b100: booth_calc = -({ {2{multiplicand[15]}}, multiplicand } << 1);  // -2 * multiplicand
                3'b101,
                3'b110: booth_calc = -{ {2{multiplicand[15]}}, multiplicand };         // -1 * multiplicand
                default: booth_calc = 18'sd0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= { {8{a[7]}}, a };  // sign-extend multiplicand to 16 bits
            multiplier_ext <= {b, 1'b0};       // multiplier extended by one 0 bit LSB (9 bits)
            product <= 18'sd0;                 // cleared partial product (2 extra bits for shifts)
            cycle <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (cycle < 4) begin
                // Extract 3 bits for Booth encoding: bits [2*cycle + 1 : 2*cycle -1]
                // Positions: bits = multiplier_ext[2*cycle+1 : 2*cycle-1]
                // Careful with indexing:
                // For cycle=0 -> bits [1: -1] is invalid, so limit the low bound at 0 and pad 0 at LSB.
                // Instead, we do:
                // bits = multiplier_ext >> (2*cycle), then take lower 3 bits.
                // Because multiplier_ext has 9 bits, max index 8.
                // This effectively means the LSB zero appended for initial previous bit.
                reg [2:0] booth_bits;
                booth_bits = multiplier_ext >> (2*cycle);
                booth_bits = booth_bits[2:0];

                // Add or subtract the multiplicand multiple to/from product
                product = product + booth_calc(booth_bits);

                // Arithmetic right shift product by 2 bits (sign-extended)
                // Since product is signed, arithmetic shift is >> 2 with sign extension
                product = product >>> 2;

                cycle = cycle + 1;
            end else begin
                // Multiplication finished, output lower 16 bits of product
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule