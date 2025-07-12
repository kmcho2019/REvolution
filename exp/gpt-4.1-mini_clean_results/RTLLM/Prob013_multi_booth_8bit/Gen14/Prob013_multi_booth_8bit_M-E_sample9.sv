module multi_booth_8bit (
    input            clk,
    input            reset,
    input      [7:0] a,     // multiplicand
    input      [7:0] b,     // multiplier
    output reg [15:0] p,    // product output
    output reg       rdy     // ready signal
);

    // Extended multiplier for Booth recoding (b_extended = {b,1'b0})
    reg [8:0] b_extended;
    // Signed multiplicand extended to 16 bits
    reg signed [15:0] multiplicand;
    // Accumulator: holds partial product and shifts
    reg signed [31:0] acc;
    // Cycle counter for 4 cycles (radix-4)
    reg [2:0] ctr;

    // Booth encoding function: given 3 bits, returns multiplier: -2, -1, 0, 1, or 2
    // Implements booth recoding table:
    // 000, 111 =  0
    // 001, 010 =  +1
    // 011       =  +2
    // 100       = -2
    // 101, 110 =  -1
    function signed [2:0] booth_encode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_encode =  3'sd0;
                3'b001, 3'b010: booth_encode =  3'sd1;
                3'b011:         booth_encode =  3'sd2;
                3'b100:         booth_encode = -3'sd2;
                3'b101, 3'b110: booth_encode = -3'sd1;
                default:        booth_encode =  3'sd0; // Safety default
            endcase
        end
    endfunction

    // Multiplexer for multiplicand multiples (x1 and x2)
    wire signed [15:0] mult_1 = multiplicand;
    wire signed [16:0] mult_2 = multiplicand <<< 1; // 17-bit for *2 to prevent overflow

    // Signal to hold Booth operation for current cycle
    reg signed [16:0] booth_op; // max width for ±2 * multiplicand

    always @(posedge clk) begin
        if (reset) begin
            // Sign extend multiplicand and multiplier, initialize accumulator and counters
            multiplicand <= { {8{a[7]}}, a };
            b_extended   <= {b, 1'b0};
            acc          <= 32'sd0;
            ctr          <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 3'd4) begin
                // Extract 3 bits for current booth recode slice
                // bits are b_extended[2*ctr+1 : 2*ctr-1], i.e. bits (2*ctr+1 downto 2*ctr-1)
                // Since ctr max 3, max index 7; b_extended is 9 bits.
                // Compute index limits safely:
                // Lower index = 2*ctr - 1, but for ctr=0 lower index is -1, clamp to 0
                integer base_idx;
                reg [2:0] booth_bits;
                base_idx = ctr*2;

                // Assemble 3 bits with zero-padding for indices <0
                // bits: b_extended[base_idx+1], b_extended[base_idx], b_extended[base_idx-1]
                // For base_idx=0, base_idx-1 = -1, so bit=0
                booth_bits[2] = b_extended[base_idx+1];
                booth_bits[1] = b_extended[base_idx];
                booth_bits[0] = (base_idx >=1) ? b_extended[base_idx-1] : 1'b0;

                // Get Booth encoded multiplier (-2 to 2)
                case (booth_encode(booth_bits))
                    3'sd0:  booth_op <= 17'sd0;
                    3'sd1:  booth_op <= {mult_1[15], mult_1};        // sign-extend 16->17 bits
                    3'sd2:  booth_op <= mult_2;
                    -3'sd1: booth_op <= -{mult_1[15], mult_1};
                    -3'sd2: booth_op <= -mult_2;
                    default: booth_op <= 17'sd0;
                endcase

                // Add booth_op shifted appropriately to accumulator
                // Accumulator is 32 bits, aligned to bit 0. We add booth_op shifted left by (2*ctr).
                // But we implement the standard approach:
                // In radix-4 Booth, we accumulate the booth_op at LSB and then arithmetic shift right by 2 bits after each addition.
                // So here, add booth_op to acc (aligned at LSB), then shift after.

                acc <= (acc + (booth_op <<< 0)) >>> 2;

                ctr <= ctr + 1;
            end else begin
                // Done with 4 cycles
                p   <= acc[15:0]; // Lower 16 bits are the final product
                rdy <= 1'b1;
            end
        end
    end
endmodule