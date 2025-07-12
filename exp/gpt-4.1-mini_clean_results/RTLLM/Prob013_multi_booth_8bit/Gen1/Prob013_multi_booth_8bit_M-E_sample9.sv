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
    reg [9:0] extended_multiplier; // multiplier extended by one LSB zero for Booth recoding
    reg [2:0] booth_bits;           // three bits for Booth recoding
    reg [2:0] ctr;                  // counts from 0 to 4 (for 4 iterations)
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
                default:        booth_decode =  3'd0; // should never happen
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend multiplicand and multiplier, add extra zero bit to multiplier LSB
            multiplicand <= {{8{a[7]}}, a};
            extended_multiplier <= {b, 1'b0};
            product <= 17'd0;
            ctr <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 3'd4) begin
                // Select bits for radix-4 booth encoding: bits 2*ctr+1 downto 2*ctr-1
                // To handle 2*ctr-1 < 0, pad with zero
                if (2*ctr == 0)
                    booth_bits = {extended_multiplier[1], extended_multiplier[0], 1'b0};
                else
                    booth_bits = extended_multiplier[2*ctr+1 -: 3];

                // Decode Booth bits to get multiplier digit (-2..2)
                // Use sign-extended 3-bit signed value from booth_decode
                reg signed [2:0] digit;
                digit = booth_decode(booth_bits);

                // Compute add_value based on digit:
                // add_value = digit * (multiplicand << (2*ctr))
                case (digit)
                    3'd2:  add_value = (multiplicand <<< (2*ctr));
                    3'd1:  add_value = (multiplicand <<< (2*ctr));
                    3'd0:  add_value = 17'd0;
                   -3'd1:  add_value = -(multiplicand <<< (2*ctr));
                   -3'd2:  add_value = - (multiplicand <<< (2*ctr));
                    default:add_value = 17'd0;
                endcase

                // For digit 2 or -2, add or subtract twice multiplicand
                if (digit == 3'd2)
                    add_value = (multiplicand <<< (2*ctr)) << 1;
                else if (digit == -3'd2)
                    add_value = -((multiplicand <<< (2*ctr)) << 1);

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