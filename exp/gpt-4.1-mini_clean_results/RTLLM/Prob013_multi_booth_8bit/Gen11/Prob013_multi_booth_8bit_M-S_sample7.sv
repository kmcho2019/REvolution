module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand input
    input      [7:0]   b,      // multiplier input
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    reg signed [15:0] multiplicand;        // sign-extended multiplicand
    reg signed [16:0] multiplier_ext;      // multiplier extended with 1 zero bit LSB
    reg signed [31:0] product;             // accumulator for partial sums
    reg [3:0] ctr;                         // iteration counter (8 iterations for 8-bit Radix-4)

    reg [2:0] booth_bits;
    reg signed [17:0] partial;             // partial product per Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand   <= {{8{a[7]}}, a};     // sign-extend multiplicand
            multiplier_ext <= {b, 1'b0};           // append 0 LSB for Booth
            product        <= 32'sd0;
            ctr            <= 4'd0;
            rdy            <= 1'b0;
            p              <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 4'd8) begin
                // Extract 3 bits for current Booth recoding: bits [2*ctr+1 : 2*ctr-1]
                booth_bits = multiplier_ext[(2*ctr)+1 -: 3];

                // Booth encoding:
                // 000,111 -> 0
                // 001,010 -> +1 * multiplicand
                // 011     -> +2 * multiplicand
                // 100     -> -2 * multiplicand
                // 101,110 -> -1 * multiplicand
                case (booth_bits)
                    3'b000, 3'b111: partial = 18'sd0;
                    3'b001, 3'b010: partial = {multiplicand,1'b0} >>> 1;       // +1 * multiplicand
                    3'b011:         partial = {multiplicand,1'b0};             // +2 * multiplicand
                    3'b100:         partial = -{multiplicand,1'b0};            // -2 * multiplicand
                    3'b101, 3'b110: partial = -({multiplicand,1'b0} >>> 1);    // -1 * multiplicand
                    default:        partial = 18'sd0;
                endcase

                // Accumulate shifted partial product (shift left by 2*ctr)
                product <= product + (partial <<< (2*ctr));

                ctr <= ctr + 1;
            end else begin
                // Multiplication complete
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule