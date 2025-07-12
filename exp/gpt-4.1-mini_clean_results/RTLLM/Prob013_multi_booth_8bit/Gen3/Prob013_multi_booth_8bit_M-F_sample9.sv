module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Registers and variables
    reg signed [15:0] multiplicand;       // sign-extended multiplicand (16 bits)
    reg [8:0] extended_multiplier;        // multiplier extended with one LSB zero (9 bits)
    reg signed [16:0] product;             // 17-bit accumulator to hold intermediate sum (with sign bit)
    reg [2:0] ctr;                         // 3-bit counter for 4 iterations (0 to 3)
    reg [2:0] booth_bits;                  // 3 bits to hold Booth encoding bits
    reg signed [2:0] digit;                // Booth digit (-2 to 2)

    integer i; // for indexing in procedural blocks

    // Function to decode radix-4 Booth from 3 bits, returning signed digit (-2 to 2)
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 3'sd0;
                3'b001, 3'b010: booth_decode = 3'sd1;
                3'b011:         booth_decode = 3'sd2;
                3'b100:         booth_decode = -3'sd2;
                3'b101, 3'b110: booth_decode = -3'sd1;
                default:        booth_decode = 3'sd0; // safe default
            endcase
        end
    endfunction

    // Function to sign-extend 16-bit input to 17-bit output (add one MSB sign bit)
    function signed [16:0] sign_extend_17;
        input [15:0] in_val;
        begin
            sign_extend_17 = {in_val[15], in_val};
        end
    endfunction

    // Function to extract 3 Booth bits from extended_multiplier for current iteration
    // bits positions: bit_high = 2*ctr + 1, bit_mid = 2*ctr, bit_low = 2*ctr - 1
    // bit_low < 0 padded with 0
    function [2:0] get_booth_bits;
        input [8:0] ext_mult;
        input [2:0] count;
        reg bit_high, bit_mid, bit_low;
        integer idx_high, idx_mid, idx_low;
        begin
            idx_high = 2*count + 1;
            idx_mid  = 2*count;
            idx_low  = 2*count - 1;

            bit_high = (idx_high <= 8) ? ext_mult[idx_high] : 1'b0;
            bit_mid  = (idx_mid  <= 8) ? ext_mult[idx_mid]  : 1'b0;
            bit_low  = (idx_low  >= 0) ? ext_mult[idx_low]  : 1'b0;

            get_booth_bits = {bit_high, bit_mid, bit_low};
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset: sign extend inputs to 16 bits and zero product and counters
            multiplicand <= {{8{a[7]}}, a};
            extended_multiplier <= {b, 1'b0}; // append zero LSB for Booth recoding
            product <= 17'sd0;
            ctr <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 3'd4) begin
                // Get 3 bits for Booth encoding
                booth_bits = get_booth_bits(extended_multiplier, ctr);

                // Decode the booth bits to digit (-2..2)
                digit = booth_decode(booth_bits);

                // Calculate shifted multiplicand (shift left by 2*ctr)
                // multiplicand sign-extended to 17 bits before shifting
                // To avoid shifting negative by variable amounts, use arithmetic shift
                // multiplicand_signext << (2*ctr)
                reg signed [16:0] shifted_multiplicand;
                shifted_multiplicand = sign_extend_17(multiplicand) <<< (2*ctr);

                // Compute add_value = digit * shifted_multiplicand
                reg signed [16:0] add_value;
                case (digit)
                    3'sd2:  add_value = shifted_multiplicand <<< 1;   // 2 * multiplicand << (2*ctr)
                    3'sd1:  add_value = shifted_multiplicand;
                    3'sd0:  add_value = 17'sd0;
                   -3'sd1:  add_value = -shifted_multiplicand;
                   -3'sd2:  add_value = -(shifted_multiplicand <<< 1);
                    default: add_value = 17'sd0;
                endcase

                // Accumulate to product
                product <= product + add_value;

                // Increment counter
                ctr <= ctr + 1;
            end else begin
                // All iterations done, output result and assert ready
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule