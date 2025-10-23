module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,       // multiplier input
    input      [7:0]   b,       // multiplicand input
    output reg [15:0]  p,       // product output
    output reg         rdy       // ready signal
);

    // States for FSM
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BUSY = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state;

    // Extended multiplier for radix-4 Booth encoding:
    // Append a zero bit at LSB: 9 bits = {a[7:0], 1'b0}
    reg signed [8:0] multiplier_ext;

    // Sign-extended multiplicand: 17 bits (one extra bit for shift left)
    reg signed [16:0] multiplicand;

    // Product accumulator, signed, 25 bits to hold max result without overflow:
    // (Because max magnitude of product is 8-bit * 8-bit = 16 bits,
    // but partial sums may extend due to radix-4 partial addition,
    // 25 bits is sufficient for accumulation with shifts)
    reg signed [24:0] product;

    // 3-bit slice for radix-4 Booth recoding (bits from multiplier_ext)
    reg [2:0] booth_bits;

    reg [3:0] cycle;  // 4 bits can count 0..8 (8 cycles for 16 bits in radix-4)

    // Function: Given 3 bits from multiplier_ext, determine multiplicand multiple:
    // returns signed 2-bit code: 
    //  0 =>  0 * multiplicand
    //  1 => +1 * multiplicand
    //  2 => +2 * multiplicand
    // -1 => -1 * multiplicand
    // -2 => -2 * multiplicand
    function automatic signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            // Radix-4 Booth recoding:
            // bits interpreted as y2y1y0 where y0 = least significant bit
            case (bits)
                3'b000,
                3'b111: booth_decode = 3'd0;    // 0
                3'b001,
                3'b010: booth_decode = 3'd1;    // +1
                3'b011: booth_decode = 3'd2;    // +2
                3'b100: booth_decode = -3'd2;   // -2
                3'b101: booth_decode = -3'd1;   // -1
                3'b110: booth_decode = -3'd1;   // -1
                default: booth_decode = 3'd0;   // default 0 for safety
            endcase
        end
    endfunction

    // Partial multiple (17 bits) for the current cycle based on booth code
    reg signed [16:0] partial_multiple;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, initialize inputs and states
            // Sign-extend multiplicand and multiplier (with appended zero)
            multiplier_ext <= {a, 1'b0};         // 9-bit extended multiplier
            multiplicand <= { {9{b[7]}}, b };   // 17-bit sign-extended multiplicand
            product <= 25'sd0;
            cycle <= 4'd0;
            rdy <= 1'b0;
            p <= 16'd0;
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    product <= 25'sd0;
                    cycle <= 4'd0;
                    state <= BUSY;
                end

                BUSY: begin
                    if (cycle < 4'd8) begin
                        // Extract 3 bits for Booth recoding:
                        // bits = multiplier_ext[2*cycle+1 : 2*cycle-1]
                        // Handle boundary for least significant group (cycle=0):
                        // indices: bit_hi = 2*cycle+1, bit_mid = 2*cycle, bit_lo = 2*cycle-1 (if <0 use 0)
                        integer bit_hi, bit_mid, bit_lo;
                        bit_hi = 2*cycle + 1;
                        bit_mid = 2*cycle;
                        bit_lo = 2*cycle - 1;

                        // Compose booth_bits safely:
                        booth_bits[2] = multiplier_ext[bit_hi];          // y2
                        booth_bits[1] = multiplier_ext[bit_mid];         // y1
                        booth_bits[0] = (bit_lo < 0) ? 1'b0 : multiplier_ext[bit_lo];  // y0 or 0 if index <0

                        // Decode Booth code for current 3-bit group
                        case (booth_decode(booth_bits))
                            3'd0:  partial_multiple = 17'sd0;
                            3'd1:  partial_multiple = multiplicand;
                            3'd2:  partial_multiple = multiplicand <<< 1;
                            -3'd1: partial_multiple = -multiplicand;
                            -3'd2: partial_multiple = -(multiplicand <<< 1);
                            default: partial_multiple = 17'sd0;
                        endcase

                        // Add partial multiple shifted by 2*cycle bits to product
                        // product += partial_multiple << (2*cycle)
                        product <= product + ( partial_multiple <<< (2*cycle) );

                        // Next cycle
                        cycle <= cycle + 1'b1;
                    end else begin
                        // All 8 cycles complete
                        // Truncate or assign lower 16 bits of product as final output
                        // The product is 25 bits signed, but final product is 16 bits signed:
                        // According to 8-bit * 8-bit multiplication, 16 bits suffice.
                        p <= product[15:0];
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Hold ready high until reset
                    rdy <= 1'b1;
                    // Optional: stay here or go back to IDLE for next multiplication
                    // To support back-to-back multiplications without reset, 
                    // you could implement handshake to accept new inputs here.
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule