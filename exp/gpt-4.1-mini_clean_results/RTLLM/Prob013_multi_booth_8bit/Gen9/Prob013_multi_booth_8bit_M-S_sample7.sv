module multi_booth_8bit (
    input               clk,
    input               reset,
    input       [7:0]   a,      // multiplicand
    input       [7:0]   b,      // multiplier
    output reg  [15:0]  p,      // product output
    output reg          rdy      // ready signal
);

    reg signed [15:0] multiplicand;      // Sign-extended multiplicand (16-bit)
    reg signed [24:0] product_reg;       // 25-bit product register: [24:9] accumulator, [8:1] multiplier, [0] appended zero for Booth
    reg [4:0]         ctr;                // 5-bit counter (max 16)

    // Extract the 3 bits needed for Booth recoding each cycle
    wire [2:0] booth_bits = product_reg[2:0];

    // Calculate partial product based on booth_bits
    reg signed [24:0] partial_mult;

    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_mult = 25'sd0;
            3'b001, 3'b010: partial_mult = {{9{multiplicand[15]}}, multiplicand};           // +M
            3'b011:         partial_mult = {{8{multiplicand[15]}}, multiplicand, 1'b0};    // +2M (shift left by 1)
            3'b100:         partial_mult = -({{8{multiplicand[15]}}, multiplicand, 1'b0}); // -2M
            3'b101, 3'b110: partial_mult = -({{9{multiplicand[15]}}, multiplicand});       // -M
            default:        partial_mult = 25'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs
            multiplicand <= { {8{a[7]}}, a };
            // Initialize product_reg with multiplier in bits [8:1] plus appended zero bit [0]
            // Upper bits accumulator zeroed
            product_reg <= {16'd0, b, 1'b0};  // 16 + 8 + 1 = 25 bits
            ctr <= 0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 8) begin
                // Add partial product to upper bits (accumulator in product_reg[24:9])
                product_reg[24:0] <= (product_reg + (partial_mult << 0)) >>> 2; // Arithmetic right shift by 2 bits

                ctr <= ctr + 1;
            end else begin
                // Multiplication complete
                p <= product_reg[24:9]; // final 16-bit product from upper bits after shifts
                rdy <= 1'b1;
            end
        end
    end

endmodule