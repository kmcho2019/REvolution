module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand input
    input      [7:0]   b,      // multiplier input
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    // Internal signals
    reg signed [16:0] multiplicand;     // sign-extended multiplicand (17-bit for safe addition)
    reg signed [17:0] accumulator;      // 18-bit to hold intermediate product (extra bit for sign)
    reg [17:0] multiplier;              // multiplier + appended 0 bit for Booth encoding (18 bits)
    reg [3:0] ctr;                     // 4-bit counter, from 0 to 8 (8 cycles for Radix-4)
    
    // Booth encoded value per cycle
    reg signed [2:0] booth_bits;       // 3 bits for current group (multiplier bits + prev bit)
    reg signed [17:0] multiplicand_shifted;  // multiplicand shifted by 2*ctr
    
    // Function to get the Booth encoded operation from 3 bits
    // Map:
    // 000, 111 -> 0
    // 001, 010 -> +1
    // 011       -> +2
    // 100       -> -2
    // 101, 110 -> -1
    function signed [1:0] booth_operation;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_operation = 2'sd0;
                3'b001, 3'b010: booth_operation = 2'sd1;
                3'b011:        booth_operation = 2'sd2;
                3'b100:        booth_operation = -2'sd2;
                3'b101, 3'b110: booth_operation = -2'sd1;
                default:       booth_operation = 2'sd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Sign-extend multiplicand to 17 bits
            multiplicand <= { {9{a[7]}}, a };
            // Sign-extend multiplier and append 0 LSB for Booth
            multiplier   <= { {9{b[7]}}, b, 1'b0 };
            accumulator  <= 18'sd0;
            ctr          <= 4'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 4'd8) begin
                // Extract 3 bits for Booth encoding: bits [2*ctr+1 : 2*ctr-1]
                // Because multiplier has appended 0 bit at LSB (bit 0),
                // we extract bits [2*ctr+1 : 2*ctr-1]
                // For ctr=0, bits[1: -1], but we padded multiplier with 0 at bit 0, so bits are safe.
                // To handle bit -1 for ctr=0, we extend multiplier with an extra 0 at LSB
                // We'll do this by shifting and masking carefully
                // Simplify: multiplier bits needed are bits [2*ctr +1 : 2*ctr -1],
                // which is 3 bits, shift multiplier right by (2*ctr -1)
                // For ctr=0: shift by -1 invalid => special case: prepend 0 bit
                // We'll shift by (2*ctr -1), but for ctr=0, extract bits [1:0] + prepend 0
                integer shift_amount;
                reg [2:0] current_bits;
                begin
                    shift_amount = (2*ctr) - 1;
                    if (shift_amount < 0) begin
                        // For ctr=0: bits are {0, multiplier[1:0]}
                        current_bits = {1'b0, multiplier[1:0]};
                    end else begin
                        current_bits = multiplier >> shift_amount;
                        current_bits = current_bits[2:0];
                    end
                end

                // Determine Booth operation
                booth_bits = current_bits;
                // Obtain operation multiplier: -2, -1, 0, 1, 2
                // Use signed 2-bit value for operation
                // Multiplicand shifted by 2*ctr bits (each cycle processes 2 bits)
                multiplicand_shifted = multiplicand <<< (2*ctr);

                case (booth_operation(booth_bits))
                    2'sd0: begin
                        // No addition
                        accumulator <= accumulator;
                    end
                    2'sd1: begin
                        // Add multiplicand shifted
                        accumulator <= accumulator + multiplicand_shifted;
                    end
                    2'sd2: begin
                        // Add 2 * multiplicand shifted = multiplicand shifted left by 1 bit
                        accumulator <= accumulator + (multiplicand_shifted <<< 1);
                    end
                    -2'sd2: begin
                        // Subtract 2 * multiplicand shifted
                        accumulator <= accumulator - (multiplicand_shifted <<< 1);
                    end
                    -2'sd1: begin
                        // Subtract multiplicand shifted
                        accumulator <= accumulator - multiplicand_shifted;
                    end
                    default: begin
                        accumulator <= accumulator;
                    end
                endcase

                ctr <= ctr + 1'b1;
            end else begin
                // All iterations done
                p   <= accumulator[15:0]; // Output lower 16 bits as product
                rdy <= 1'b1;
            end
        end
    end

endmodule