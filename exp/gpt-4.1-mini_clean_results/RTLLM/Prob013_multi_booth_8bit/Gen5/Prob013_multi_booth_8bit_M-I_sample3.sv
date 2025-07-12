module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Sign-extended multiplicand
    reg signed [15:0] multiplicand;
    // Multiplier extended with one LSB zero for Booth recoding
    reg [8:0] extended_multiplier;
    // Product accumulator (one extra bit for sign/overflow)
    reg signed [16:0] product;
    // 2-bit counter for 4 iterations (0..3)
    reg [1:0] ctr;
    // Booth bits and decoded digit
    reg [2:0] booth_bits;
    reg signed [2:0] digit;

    // Intermediate registers for shifted multiplicand and add value
    reg signed [16:0] shifted_mul;
    reg signed [16:0] add_val;

    // Function to decode radix-4 Booth digits from 3 bits
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 3'sd0;
                3'b001, 3'b010: booth_decode = 3'sd1;
                3'b011:         booth_decode = 3'sd2;
                3'b100:         booth_decode = -3'sd2;
                3'b101, 3'b110: booth_decode = -3'sd1;
                default:        booth_decode = 3'sd0;
            endcase
        end
    endfunction

    // Extract booth bits at iteration ctr: bits [2*ctr+1 : 2*ctr-1]
    // If index < 0, treat bit as 0
    function [2:0] get_booth_bits;
        input [8:0] ext_mult;
        input [1:0] count;
        reg bit_high, bit_mid, bit_low;
        integer i_high, i_mid, i_low;
        begin
            i_high = 2*count + 1;
            i_mid  = 2*count;
            i_low  = 2*count - 1;

            bit_high = (i_high <= 8) ? ext_mult[i_high] : 1'b0;
            bit_mid  = (i_mid  <= 8) ? ext_mult[i_mid]  : 1'b0;
            bit_low  = (i_low  >= 0) ? ext_mult[i_low]  : 1'b0;

            get_booth_bits = {bit_high, bit_mid, bit_low};
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a};         // Sign-extend multiplicand to 16 bits
            extended_multiplier <= {b, 1'b0};        // Append zero LSB to multiplier for Booth encoding
            product <= 17'sd0;
            ctr <= 2'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 2'd4) begin
                // Extract Booth encoding bits
                booth_bits = get_booth_bits(extended_multiplier, ctr);
                // Decode to digit (-2 to 2)
                digit = booth_decode(booth_bits);

                // Shift multiplicand left by 2*ctr (equivalent to multiply by 4^ctr)
                shifted_mul = {multiplicand[15], multiplicand} <<< (2*ctr);

                // Multiply shifted multiplicand by digit
                case (digit)
                    3'sd2:  add_val = shifted_mul <<< 1; // *2
                    3'sd1:  add_val = shifted_mul;
                    3'sd0:  add_val = 17'sd0;
                   -3'sd1:  add_val = -shifted_mul;
                   -3'sd2:  add_val = -(shifted_mul <<< 1);
                    default: add_val = 17'sd0;
                endcase

                // Accumulate partial product
                product <= product + add_val;
                ctr <= ctr + 1;
            end else begin
                // Multiplication finished, output result and set ready
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule