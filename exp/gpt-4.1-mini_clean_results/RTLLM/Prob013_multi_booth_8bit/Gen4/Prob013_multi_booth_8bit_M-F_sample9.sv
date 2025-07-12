module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg signed [15:0] multiplicand;       // Sign-extended multiplicand
    reg signed [16:0] multiplier_extended; // multiplier with appended 0 bit (for Booth encoding)
    reg signed [31:0] product;             // Accumulated product (wide enough for intermediate sums)
    reg [2:0] ctr;                        // Counter for cycles (0 to 3)

    // Booth encoding function: input is 3 bits
    // Returns:
    //  0: 0 * multiplicand
    //  1: +1 * multiplicand
    //  2: +2 * multiplicand
    // -1: -1 * multiplicand
    // -2: -2 * multiplicand
    // Encoding rules (bits = y_{i+1} y_i y_{i-1}):
    // 000 => 0
    // 001 => +1
    // 010 => +1
    // 011 => +2
    // 100 => -2
    // 101 => -1
    // 110 => -1
    // 111 => 0
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 0;
                3'b001, 3'b010: booth_decode = 1;
                3'b011:        booth_decode = 2;
                3'b100:        booth_decode = -2;
                3'b101, 3'b110: booth_decode = -1;
                default:       booth_decode = 0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= { {8{a[7]}}, a };   // sign-extend multiplicand
            multiplier_extended <= { {1'b0}, { {8{b[7]}}, b } }; // sign-extend multiplier and append zero LSB
            product <= 32'd0;
            ctr <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 4) begin
                // Extract 3 bits for Booth encoding: bits [2:0] from multiplier_extended shifted by 2*ctr
                // Example: for ctr=0, bits[2:0] = multiplier_extended[2:0]
                // for ctr=1, bits[4:2], etc.
                // Because multiplier_extended has 17 bits, max bits read: 2*3+2=8 bits max - safe
                reg [2:0] booth_bits;
                reg signed [31:0] addend;
                reg signed [2:0] booth_op;
                begin
                    booth_bits = multiplier_extended[2*ctr +: 3]; // 3 bits starting at 2*ctr

                    booth_op = booth_decode(booth_bits);

                    // Calculate addend = multiplicand * booth_op shifted left by 2*ctr
                    // multiplicand is 16-bit signed, extend to 32-bit for shifting and addition
                    // Use 32-bit signed arithmetic
                    case (booth_op)
                        3'd0: addend = 32'd0;
                        3'd1: addend = (multiplicand <<< (2*ctr));
                        3'd2: addend = (multiplicand <<< (2*ctr+1)); // multiply by 2 is shift left by 1
                        -3'd1: addend = -(multiplicand <<< (2*ctr));
                        -3'd2: addend = -(multiplicand <<< (2*ctr+1));
                        default: addend = 32'd0;
                    endcase

                    product <= product + addend;
                    ctr <= ctr + 1'b1;
                end
            end else begin
                // Multiplication finished after 4 cycles
                p <= product[15:0];  // lower 16 bits contain the product
                rdy <= 1'b1;
            end
        end
        // When rdy is high, hold product and ready until next reset
    end
endmodule