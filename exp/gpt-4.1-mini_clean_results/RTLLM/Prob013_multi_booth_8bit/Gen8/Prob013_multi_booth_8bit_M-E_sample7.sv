module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,       // multiplicand
    input wire [7:0] b,       // multiplier
    output reg [15:0] p,      // product output
    output reg rdy            // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand;    // sign-extended multiplicand (16 bits)
    reg [8:0] multiplier;               // multiplier plus appended zero bit (9 bits)
    reg signed [31:0] acc;              // accumulator (32 bits to avoid overflow)
    reg [2:0] cycle_cnt;                // counts 0 to 3 for 4 Radix-4 cycles

    // Booth encoding function to convert 3 bits to multiplier factor
    // Encoding table (bits[2:0]):
    // 000, 111 -> 0
    // 001, 010 -> +1
    // 011      -> +2
    // 100      -> -2
    // 101,110  -> -1
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

    // Signed multiplication by small multiplier (-2 to +2)
    function signed [31:0] mult_by_booth_factor;
        input signed [15:0] mcand;
        input signed [2:0] factor;
        reg signed [31:0] mcand_32;
        begin
            mcand_32 = {{16{mcand[15]}}, mcand}; // sign-extend to 32 bits
            case (factor)
                3'd0:  mult_by_booth_factor = 32'd0;
                3'd1:  mult_by_booth_factor = mcand_32;
                3'd2:  mult_by_booth_factor = mcand_32 <<< 1;
                -3'd1: mult_by_booth_factor = -mcand_32;
                -3'd2: mult_by_booth_factor = -(mcand_32 <<< 1);
                default: mult_by_booth_factor = 32'd0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= { {8{a[7]}}, a };       // sign-extend multiplicand to 16 bits
            multiplier <= {b, 1'b0};                 // append zero bit to multiplier LSB (for Booth)
            acc <= 32'd0;
            cycle_cnt <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            // Perform one Booth cycle per clock while not ready
            // Extract the least 3 bits for booth encoding from multiplier
            // bits: multiplier[1:0] plus multiplier[0] shifted down to form 3 bits total
            // Actually just multiplier[2:0], since multiplier is 9 bits, bits 2:0 are valid
            // Note that multiplier[0] is appended zero, so multiplier[2:0] can be used directly
            reg [2:0] booth_bits;
            reg signed [2:0] factor;
            reg signed [31:0] pp;  // partial product

            booth_bits = multiplier[2:0];
            factor = booth_decode(booth_bits);
            pp = mult_by_booth_factor(multiplicand, factor);

            // Add partial product to accumulator
            acc <= acc + pp;

            // Arithmetic right shift combined {acc, multiplier} by 2 bits
            // combined is 41 bits: acc[31:0] concatenated with multiplier[8:0]
            // Perform signed arithmetic shift right 2 of this 41-bit vector
            reg signed [40:0] combined;
            reg signed [40:0] combined_shifted;
            combined = {acc, multiplier};
            combined_shifted = combined >>> 2;

            // Update acc and multiplier after shift
            acc <= combined_shifted[40:9];       // upper 32 bits after shift
            multiplier <= combined_shifted[8:0]; // lower 9 bits after shift

            // Increment cycle count
            cycle_cnt <= cycle_cnt + 1;

            if (cycle_cnt == 3'd3) begin
                // After 4 cycles (0..3), multiplication done
                // The product is the lower 16 bits of accumulator (bits 15:0)
                p <= combined_shifted[24:9]; // bits 24 down to 9 is 16 bits accumulator lower part after shift
                rdy <= 1'b1;
            end
        end
        // else rdy == 1: hold output stable, wait for reset to start new operation
    end

endmodule