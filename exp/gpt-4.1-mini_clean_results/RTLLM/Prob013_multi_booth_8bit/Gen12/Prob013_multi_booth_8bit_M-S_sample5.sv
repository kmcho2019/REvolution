module multi_booth_8bit (
    input            clk,
    input            reset,
    input  [7:0]     a,   // multiplicand
    input  [7:0]     b,   // multiplier
    output reg [15:0] p,  // product
    output reg       rdy   // ready signal
);

    reg signed [15:0] multiplicand;
    reg signed [16:0] multiplier_ext; // multiplier extended with appended 0 at LSB
    reg signed [31:0] product;        // accumulator holds partial product + multiplier combined
    reg [3:0]         count;

    // Decode Booth encoding for 3 bits to multiplier of multiplicand
    // Returns signed integer: 0, ±1, ±2 times multiplicand
    function signed [17:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 18'sd0;
                3'b001, 3'b010: booth_decode = {multiplicand[15], multiplicand};// +1 * multiplicand
                3'b011:         booth_decode = ({multiplicand[15], multiplicand} << 1); // +2 * multiplicand
                3'b100:         booth_decode = -({multiplicand[15], multiplicand} << 1); // -2 * multiplicand
                3'b101, 3'b110: booth_decode = -{multiplicand[15], multiplicand};       // -1 * multiplicand
                default:        booth_decode = 18'sd0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand   <= { {8{a[7]}}, a };     // sign-extend a to 16 bits
            multiplier_ext <= {b, 1'b0};            // 8 bits b + appended 0 at LSB
            product        <= 32'd0;                // clear product
            count          <= 4'd0;
            rdy            <= 1'b0;
            p              <= 16'd0;
        end else begin
            if (count < 4'd8) begin
                // Extract 3 bits for Booth encoding from multiplier_ext[2:0]
                // The 3 bits to determine operation: bits [2:0] of multiplier_ext
                reg [2:0] booth_bits;
                reg signed [17:0] add_val;

                booth_bits = multiplier_ext[2:0];
                add_val = booth_decode(booth_bits);

                // Add or subtract multiplicand multiple to higher 18 bits of product
                // product[31:14] holds partial product (18 bits)
                product[31:14] = product[31:14] + add_val;

                // Arithmetic right shift product + multiplier_ext by 2 bits
                // product and multiplier_ext combined into 33 bits:
                // product[31:0] + multiplier_ext LSB (1 bit)
                // We'll merge multiplier_ext LSB with product[13:0]
                // For simplicity, store combined 34 bits in a temporary variable

                reg signed [33:0] combined;
                combined = {product, multiplier_ext[0]};

                combined = combined >>> 2; // arithmetic right shift by 2 bits

                // Update product and multiplier_ext after shift
                product        <= combined[33:2];
                multiplier_ext <= {multiplier_ext[16:1], 1'b0}; // shift multiplier_ext right 2 bits with zero fill at MSB

                // To keep multiplier_ext aligned with shift, extract from combined
                // Instead, assign multiplier_ext from lower bits of combined
                multiplier_ext <= combined[1:0] | (multiplier_ext >> 2);

                // But we must ensure multiplier_ext gets bits from combined after shift
                multiplier_ext <= combined[1:0] | (combined[33:32] << 1);
                // Actually better assign multiplier_ext from combined lower bits:

                multiplier_ext <= combined[1:0] | (combined[33:32] << 1);

                // Actually to keep logic clean, just assign multiplier_ext = combined[16:0]
                multiplier_ext <= combined[16:0];

                count <= count + 1'b1;
            end else if (!rdy) begin
                // Once done, output the final product
                p   <= product[31:16]; // upper 16 bits hold the result
                rdy <= 1'b1;
            end
        end
    end

endmodule