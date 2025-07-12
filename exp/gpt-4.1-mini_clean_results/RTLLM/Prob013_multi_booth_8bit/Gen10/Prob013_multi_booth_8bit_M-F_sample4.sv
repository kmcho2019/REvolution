module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand
    input      [7:0]   b,      // multiplier
    output reg [15:0]  p,      // product
    output reg         rdy     // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand;            // sign-extended multiplicand
    reg [9:0] extended_multiplier;             // multiplier with 2 zero bits appended for Booth encoding (8+2=10 bits)
    reg signed [33:0] product;                  // accumulator, enough width to hold intermediate results (34 bits)
    reg [2:0] cycle_cnt;                        // 0..4 cycles for radix-4 (4 cycles total)

    // Extract current Booth bits: 3 bits from extended_multiplier starting at (2*cycle_cnt)
    wire [2:0] booth_bits = extended_multiplier[2*cycle_cnt +: 3];

    // Decode Booth bits combinationally to factor: -2, -1, 0, 1, 2
    reg signed [2:0] booth_factor;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_factor =  3'sd0;
            3'b001, 3'b010: booth_factor =  3'sd1;
            3'b011:         booth_factor =  3'sd2;
            3'b100:         booth_factor = -3'sd2;
            3'b101, 3'b110: booth_factor = -3'sd1;
            default:        booth_factor =  3'sd0;
        endcase
    end

    // Generate partial product based on booth_factor
    reg signed [16:0] partial_product;  // 17 bits to hold multiplicand * factor (-2 to 2)
    always @(*) begin
        case (booth_factor)
            3'sd0:  partial_product = 17'sd0;
            3'sd1:  partial_product = {multiplicand[15], multiplicand};           // multiplicand
            3'sd2:  partial_product = ({multiplicand[15], multiplicand} << 1);    // multiplicand * 2
           -3'sd1:  partial_product = -{multiplicand[15], multiplicand};
           -3'sd2:  partial_product = -({multiplicand[15], multiplicand} << 1);
            default: partial_product = 17'sd0;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand        <= {{8{a[7]}}, a};         // sign-extend multiplicand
            extended_multiplier <= {b, 2'b00};              // multiplier + 2 appended zero bits
            product             <= 34'sd0;
            cycle_cnt           <= 3'd0;
            p                   <= 16'd0;
            rdy                 <= 1'b0;
        end else if (!rdy) begin
            if (cycle_cnt < 3'd4) begin
                // Add partial product aligned to LSB (bits [16:0]) of product
                product <= (product >>> 2) + ({{17{partial_product[16]}}, partial_product} <<< 0);
                // Shift product right 2 bits arithmetic shift to prepare for next cycle
                cycle_cnt <= cycle_cnt + 1'b1;
            end else begin
                // Multiplication complete
                p   <= product[15:0];  // final 16-bit product (lower 16 bits)
                rdy <= 1'b1;
            end
        end
    end

endmodule