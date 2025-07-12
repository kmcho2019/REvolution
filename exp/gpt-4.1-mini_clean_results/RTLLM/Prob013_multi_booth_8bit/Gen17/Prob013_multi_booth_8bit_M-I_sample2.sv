module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,      // multiplicand (signed)
    input  [7:0]    b,      // multiplier   (signed)
    output reg [15:0] p,    // product
    output reg       rdy     // ready signal
);

    // Internal signed registers
    reg signed [15:0] accumulator;    // 16-bit accumulator (product)
    reg signed [16:0] multiplier;     // multiplier extended with 1 LSB zero and 1 MSB sign extension: [16] sign, [15:0] b + appended 0 LSB
    reg signed [15:0] multiplicand;   // 16-bit sign-extended multiplicand

    reg [2:0] step;                   // 0 to 4 cycles needed (actually 4 cycles for 8-bit radix-4)
    reg prev_lsb;                    // bit -1 for Booth recoding (previous LSB)

    wire [2:0] booth_bits;           // 3 bits for Booth code: {multiplier[1], multiplier[0], prev_lsb}

    // Compute booth_bits for Radix-4 recoding
    assign booth_bits = {multiplier[1], multiplier[0], prev_lsb};

    // Partial product based on Booth encoding (16 bits signed)
    reg signed [15:0] partial_product;

    always @(*) begin
        case (booth_bits)
            3'b000,
            3'b111: partial_product = 16'sd0;
            3'b001,
            3'b010: partial_product = multiplicand;               // +1 * multiplicand
            3'b011: partial_product = multiplicand <<< 1;         // +2 * multiplicand
            3'b100: partial_product = -(multiplicand <<< 1);      // -2 * multiplicand
            3'b101,
            3'b110: partial_product = -multiplicand;              // -1 * multiplicand
            default: partial_product = 16'sd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Load inputs and initialize registers
            // Sign-extend inputs to 16 bits
            multiplicand <= {{8{a[7]}}, a};
            // multiplier extended: b + appended 0 LSB + sign bit at MSB (for arithmetic shift)
            multiplier <= {b[7], b, 1'b0};
            accumulator <= 16'sd0;
            step <= 3'd0;
            prev_lsb <= 1'b0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Multiply process ongoing

            // Accumulate partial product
            accumulator <= accumulator + partial_product;

            // Arithmetic right shift multiplier by 2 bits with sign extension
            // Save current LSB to prev_lsb before shift
            prev_lsb <= multiplier[0];
            multiplier <= {multiplier[16], multiplier[16:2]};  // replicate MSB for sign-extension

            step <= step + 1'b1;

            if (step == 3'd3) begin
                // Done after 4 radix-4 steps (covers all 8 bits)
                p <= accumulator + partial_product; // Add last partial product
                rdy <= 1'b1;
            end
        end
    end

endmodule