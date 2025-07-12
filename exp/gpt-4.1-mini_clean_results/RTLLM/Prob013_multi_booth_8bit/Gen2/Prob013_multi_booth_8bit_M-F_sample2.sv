module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg signed [16:0] product;      // accumulator with extra bit for sign/overflow
    reg signed [15:0] multiplicand; // sign-extended multiplicand
    reg [8:0] extended_multiplier; // multiplier extended by one LSB zero for Booth recoding (8 bits + 1)
    reg [2:0] booth_bits;           // three bits for Booth recoding
    reg [2:0] ctr;                  // counts from 0 to 4 (for 4 iterations)
    reg signed [2:0] digit;         // Booth decoded digit (-2..2)
    reg signed [16:0] add_value;    // value to add/subtract based on encoding

    // Function to decode radix-4 Booth from 3 bits, returning -2,-1,0,1,2
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode =  3'd0;
                3'b001, 3'b010: booth_decode =  3'd1;
                3'b011:         booth_decode =  3'd2;
                3'b100:         booth_decode = -3'd2;
                3'b101, 3'b110: booth_decode = -3'd1;
                default:        booth_decode =  3'd0; // safe default
            endcase
        end
    endfunction

    // Sign extend a value of width 'in_width' to 17 bits
    function signed [16:0] sign_extend_17;
        input [15:0] in_val;
        begin
            sign_extend_17 = {{1{in_val[15]}}, in_val};
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend multiplicand and multiplier, add zero LSB to multiplier for booth recoding
            multiplicand <= {{8{a[7]}}, a};
            extended_multiplier <= {b, 1'b0}; // 9 bits
            product <= 17'd0;
            ctr <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 3'd4) begin
                // Extract booth_bits = multiplier bits [2*ctr+1 : 2*ctr-1]
                // Handle case when 2*ctr -1 < 0 (pad with zero)
                // We build bits in order: MSB down to LSB -> bits[2:0]
                // Positions: 
                // bit_high = 2*ctr +1
                // bit_mid  = 2*ctr
                // bit_low  = 2*ctr -1 (if <0 pad 0)
                integer bit_high, bit_mid, bit_low;
                bit_high = 2*ctr + 1;
                bit_mid  = 2*ctr;
                bit_low  = 2*ctr - 1;
                booth_bits[2] = (bit_high <= 8) ? extended_multiplier[bit_high] : 1'b0;
                booth_bits[1] = (bit_mid  <= 8) ? extended_multiplier[bit_mid ] : 1'b0;
                booth_bits[0] = (bit_low  >= 0) ? extended_multiplier[bit_low ] : 1'b0;

                // Decode Booth bits to get multiplier digit (-2..2)
                digit = booth_decode(booth_bits);

                // Calculate add_value = digit * multiplicand << (2*ctr)
                // Shift multiplicand left by 2*ctr bits, then multiply by digit
                // First, shift multiplicand to 17 bits with sign extension before shifting
                // Use a 17-bit intermediate shifted multiplicand
                reg signed [16:0] shifted_multiplicand;
                shifted_multiplicand = sign_extend_17(multiplicand) <<< (2*ctr);

                case (digit)
                    3'd2:  add_value = shifted_multiplicand <<< 1;  // 2 * multiplicand
                    3'd1:  add_value = shifted_multiplicand;
                    3'd0:  add_value = 17'd0;
                   -3'd1:  add_value = -shifted_multiplicand;
                   -3'd2:  add_value = -(shifted_multiplicand <<< 1);
                    default:add_value = 17'd0;
                endcase

                // Accumulate to product
                product <= product + add_value;

                ctr <= ctr + 1;
            end else begin
                // Done after 4 iterations
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule