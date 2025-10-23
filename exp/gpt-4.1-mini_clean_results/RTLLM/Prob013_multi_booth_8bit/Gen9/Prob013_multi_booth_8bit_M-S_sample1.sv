module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,    // multiplicand
    input      [7:0]   b,    // multiplier
    output reg [15:0]  p,    // product output
    output reg         rdy    // ready signal
);

    // Extended multiplicand (16 bits signed)
    reg signed [15:0] multiplicand;

    // Extended multiplier (9 bits: 8 bits + appended zero for Booth encoding)
    reg [8:0] multiplier_ext;

    // Accumulator for partial products (32 bits signed to avoid overflow)
    reg signed [31:0] partial_product;

    // Cycle counter for 8 cycles (processing 2 bits per cycle)
    reg [3:0] cycle_cnt;

    // 3-bit Booth code extracted each cycle
    reg [2:0] booth_bits;

    // Multiplication factor (-2, -1, 0, 1, 2)
    reg signed [2:0] mult_factor;

    // Temporary addend (partial product to add)
    reg signed [31:0] addend;

    // Booth decoding function for 3 bits to -2..+2
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_decode = 3'd0;
                3'b001, 3'b010: booth_decode = 3'd1;
                3'b011:         booth_decode = 3'd2;
                3'b100:         booth_decode = -3'd2;
                3'b101, 3'b110: booth_decode = -3'd1;
                default:        booth_decode = 3'd0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend multiplicand to 16 bits
            multiplicand <= { {8{a[7]}}, a };

            // Load multiplier with appended zero bit at LSB
            multiplier_ext <= {b, 1'b0};

            // Clear partial product and cycle count
            partial_product <= 32'sd0;
            cycle_cnt       <= 4'd0;

            // Clear output signals
            p   <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (cycle_cnt < 4'd8) begin
                // Extract 3 bits for current Booth encoding: bits [1:0] + bit -1 (zero if not exists)
                // For multiplier_ext shifted right by 2*cycle_cnt, bits 2*cycle_cnt + 1 : 2*cycle_cnt -1
                // Because multiplier_ext shifts right by 2 bits each cycle, just take bits [2*cycle_cnt+1 : 2*cycle_cnt-1]
                // We can directly take bits [1:0] + bit -1 of multiplier_ext
                // Since multiplier_ext is shifted each cycle, we can always extract bits [1:0] + bit -1 at LSB

                // Booth bits are multiplier_ext[1:0] and multiplier_ext[-1], 
                // but since index -1 not valid, assume zero if cycle_cnt==0
                if (cycle_cnt == 0)
                    booth_bits = {multiplier_ext[1:0], 1'b0};
                else
                    booth_bits = {multiplier_ext[1:0], multiplier_ext[2]}; // use bit 2 as bit -1 shifted in previous cycle

                // Decode Booth bits to multiplication factor
                mult_factor = booth_decode(booth_bits);

                // Compute addend without using '*':
                // mult_factor can be -2, -1, 0, 1, 2
                // For ±2: shift multiplicand by 1 (multiply by 2), then sign
                // For ±1: multiplicand or -multiplicand
                // For 0: zero
                case(mult_factor)
                    3'd2:   addend = multiplicand <<< 1;       // +2 * multiplicand
                    -3'd2:  addend = - (multiplicand <<< 1);  // -2 * multiplicand
                    3'd1:   addend = multiplicand;             // +1 * multiplicand
                    -3'd1:  addend = -multiplicand;            // -1 * multiplicand
                    default:addend = 32'sd0;                    // 0
                endcase

                // Shift addend by 2*cycle_cnt bits (equivalent to left shift)
                addend = addend <<< (2*cycle_cnt);

                // Accumulate partial product
                partial_product <= partial_product + addend;

                // Shift multiplier right by 2 bits for next cycle
                multiplier_ext <= multiplier_ext >> 2;

                // Increment cycle count
                cycle_cnt <= cycle_cnt + 1;
            end else begin
                // Multiplication complete: output lower 16 bits
                p   <= partial_product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule