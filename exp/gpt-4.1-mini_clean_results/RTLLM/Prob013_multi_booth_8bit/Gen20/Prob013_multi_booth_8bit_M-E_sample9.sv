module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,       // multiplier input
    input      [7:0]   b,       // multiplicand input
    output reg [15:0]  p,       // product output
    output reg         rdy       // ready signal
);

    // Internal registers
    reg [8:0] multiplier_reg;       // 8 bits multiplier + 1 bit (for Booth encoding)
    reg signed [16:0] multiplicand_reg;  // multiplicand shifted left by 8 bits for alignment
    reg signed [16:0] partial_product;    // accumulator register for partial product
    reg [3:0] count;                 // count how many multiplier bits processed (increments by 2)

    // Function to compute Booth operation based on 3 bits
    // Returns signed 17-bit value to be added to partial product
    function signed [16:0] booth_op;
        input [2:0] booth_bits;
        input signed [16:0] m;
        begin
            case (booth_bits)
                3'b000, 3'b111: booth_op = 17'sd0;          // 0
                3'b001, 3'b010: booth_op = m;                // +1 * multiplicand
                3'b011:         booth_op = m <<< 1;          // +2 * multiplicand
                3'b100:         booth_op = - (m <<< 1);      // -2 * multiplicand
                3'b101, 3'b110: booth_op = -m;               // -1 * multiplicand
                default:       booth_op = 17'sd0;             // default zero
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            // multiplicand shifted left by 8 for alignment in 17 bits:
            // sign-extend b to 9 bits, shift left 8 => 17 bits total
            multiplicand_reg <= {{9{b[7]}}, b} <<< 8;

            // multiplier_reg = multiplier (a) concatenated with 1 trailing zero bit
            multiplier_reg <= {a, 1'b0};

            partial_product <= 17'sd0;
            count <= 4'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // If not ready, process next Booth cycle
            if (count < 8) begin
                // Extract 3 bits from multiplier_reg for Booth encoding (bits [2:0])
                // The multiplier_reg shifts right 2 bits each cycle
                reg [2:0] booth_bits;
                booth_bits = multiplier_reg[2:0];

                // Compute addend according to Booth encoding
                reg signed [16:0] addend;
                addend = booth_op(booth_bits, multiplicand_reg);

                // Add addend to partial product
                partial_product <= partial_product + addend;

                // Arithmetic right shift combined (partial product and multiplier_reg) by 2 bits:
                // The architecture shifts partial_product and multiplier_reg together:
                // After addition, shift partial_product and multiplier_reg combined right 2 bits logically

                // Create a 26-bit combined register:
                // partial_product (17 bits) concatenated with multiplier_reg (9 bits)
                // Shift right arithmetic 2 bits

                reg signed [25:0] combined;
                combined = {partial_product + addend, multiplier_reg};
                combined = combined >>> 2;

                // Update registers with shifted values:
                partial_product <= combined[25:9];
                multiplier_reg <= combined[8:0];

                count <= count + 2;
            end else begin
                // Multiplication finished
                p <= partial_product[15:0]; // Output lower 16 bits of partial product
                rdy <= 1'b1;
            end
        end else begin
            // Hold ready and output stable until reset
            rdy <= 1'b1;
            p <= p;
        end
    end

endmodule