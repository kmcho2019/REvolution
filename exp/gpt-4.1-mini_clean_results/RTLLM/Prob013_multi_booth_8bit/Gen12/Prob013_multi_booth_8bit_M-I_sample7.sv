module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand input
    input      [7:0]   b,      // multiplier input
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    // Precomputed multiplicand multiples
    reg signed [16:0] multiplicand;       // sign-extended multiplicand (17-bit for 2*multiplicand)
    reg signed [16:0] multiplicand_1x;   // +1 * multiplicand (17-bit)
    reg signed [16:0] multiplicand_2x;   // +2 * multiplicand (17-bit)

    reg signed [17:0] multiplier_ext;    // multiplier with appended zero LSB (18 bits)
    reg signed [31:0] product;            // 32-bit accumulator for product

    reg [3:0] ctr;                       // 4-bit counter for 8 iterations (2 bits per iteration)
    reg [2:0] booth_bits;                // 3 bits from multiplier for Booth encoding

    reg signed [17:0] partial;           // partial product for current step

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend multiplicand to 17 bits (for 2*multiplicand within 17 bits)
            multiplicand   <= {{9{a[7]}}, a};
            multiplicand_1x <= {{9{a[7]}}, a};           // 1x multiplicand
            multiplicand_2x <= ({{9{a[7]}}, a} <<< 1);  // 2x multiplicand = multiplicand shifted left by 1
            multiplier_ext <= {b, 1'b0};                  // multiplier concatenated with zero LSB for Booth
            product        <= 32'sd0;
            ctr            <= 4'd0;
            rdy            <= 1'b0;
            p              <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 4'd8) begin
                // Extract 3 bits for Booth encoding: bits [2*ctr+1 : 2*ctr-1]
                // Using bit slicing with variable MSB and LSB
                booth_bits = multiplier_ext[(2*ctr)+1 -: 3];

                // Generate partial product based on Booth encoding
                case (booth_bits)
                    3'b000, 3'b111: partial = 18'sd0;
                    3'b001, 3'b010: partial = {multiplicand_1x,1'b0} >>> 1;   // +1 * multiplicand (shift right to 17 bits)
                    3'b011:         partial = {multiplicand_2x,1'b0};         // +2 * multiplicand (multiplied by 2)
                    3'b100:         partial = -({multiplicand_2x,1'b0});      // -2 * multiplicand
                    3'b101, 3'b110: partial = -({multiplicand_1x,1'b0} >>> 1);// -1 * multiplicand
                    default:        partial = 18'sd0;
                endcase

                // Accumulate shifted partial product; shift left by 2*ctr because each iteration processes 2 bits
                // Note: partial is 18 bits, product is 32 bits
                product <= product + ({{14{partial[17]}}, partial} <<< (2*ctr)); // sign extend partial to 32 bits before shift

                ctr <= ctr + 1;
            end else begin
                p <= product[15:0];  // output lower 16 bits as product
                rdy <= 1'b1;
            end
        end
    end

endmodule