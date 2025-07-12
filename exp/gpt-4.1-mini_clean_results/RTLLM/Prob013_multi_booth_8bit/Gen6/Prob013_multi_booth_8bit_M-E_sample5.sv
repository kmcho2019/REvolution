module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,      // multiplicand
    input [7:0] b,      // multiplier
    output reg [15:0] p, // product output
    output reg rdy       // ready signal
);

    // Extended multiplicand and multiplier registers
    reg signed [15:0] multiplicand;  // sign-extended multiplicand
    reg [8:0] multiplier_ext;        // multiplier extended with appended zero bit: {b,0}

    reg signed [31:0] product_accum; // accumulator for partial products

    reg [2:0] iteration;             // counts 0..3 for 4 Radix-4 steps

    reg [2:0] booth_bits;            // current 3-bit Booth code

    // Generate Booth code for current iteration
    // booth_bits = multiplier_ext[2*iteration + 1 : 2*iteration - 1]
    // Handle lower bound index properly; out-of-range bits treated as 0

    // Function to get one bit of multiplier_ext safely (0 if out of range)
    function bit get_multiplier_bit;
        input integer idx;
        begin
            if (idx < 0 || idx > 8)
                get_multiplier_bit = 1'b0;
            else
                get_multiplier_bit = multiplier_ext[idx];
        end
    endfunction

    // Decode Booth bits to partial product multiplier
    // Encodings:  
    // 000, 111 => 0
    // 001, 010 => +1 * multiplicand
    // 011      => +2 * multiplicand
    // 100      => -2 * multiplicand
    // 101, 110 => -1 * multiplicand

    function signed [17:0] booth_partial_product;
        input [2:0] bits;
        input signed [15:0] mcand;
        reg signed [17:0] mcand_ext;
        begin
            // Sign-extend multiplicand to 18 bits for safe 2x shifts
            mcand_ext = {mcand[15], mcand};

            case (bits)
                3'b000, 3'b111: booth_partial_product = 18'sd0;
                3'b001, 3'b010: booth_partial_product = mcand_ext;
                3'b011: booth_partial_product = mcand_ext <<< 1; // x2
                3'b100: booth_partial_product = -(mcand_ext <<< 1); // -2x
                3'b101, 3'b110: booth_partial_product = -mcand_ext;
                default: booth_partial_product = 18'sd0;
            endcase
        end
    endfunction

    // Combinational process to get booth_bits and partial product shifted by (2*iteration)
    reg signed [31:0] partial_product_shifted;
    integer idx_high, idx_mid, idx_low;

    always @(*) begin
        // Calculate booth_bits safely
        idx_high = 2 * iteration + 1;
        idx_mid  = 2 * iteration;
        idx_low  = 2 * iteration - 1;

        booth_bits[2] = get_multiplier_bit(idx_high);
        booth_bits[1] = get_multiplier_bit(idx_mid);
        booth_bits[0] = get_multiplier_bit(idx_low);

        // Get partial product (18 bits)
        partial_product_shifted = booth_partial_product(booth_bits, multiplicand);
        // Shift partial product left by 2 * iteration bits (0,2,4,6)
        partial_product_shifted = partial_product_shifted <<< (2 * iteration);
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            multiplicand   <= {{8{a[7]}}, a};          // sign-extend multiplicand to 16 bits
            multiplier_ext <= {b, 1'b0};                // multiplier + appended zero bit (LSB)
            product_accum  <= 32'sd0;
            iteration      <= 3'd0;
            rdy            <= 1'b0;
            p              <= 16'd0;
        end else begin
            if (iteration < 3'd4) begin
                // Accumulate partial product
                product_accum <= product_accum + partial_product_shifted;
                iteration <= iteration + 1;
                rdy <= 1'b0;
                p <= 16'd0;
            end else begin
                // Multiplication done
                rdy <= 1'b1;
                p <= product_accum[15:0]; // lower 16 bits of product
                // Hold state or optionally could freeze registers here
            end
        end
    end

endmodule