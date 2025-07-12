module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,      // multiplicand
    input [7:0] b,      // multiplier
    output reg [15:0] p, // product output
    output reg rdy       // ready signal
);

    // Internal signals
    reg signed [15:0] multiplicand;   // sign-extended multiplicand
    reg [17:0] multiplier_ext;        // extended multiplier with one appended zero bit (for Booth recoding)
    reg signed [31:0] product;        // accumulator for partial products
    reg [4:0] ctr;                    // 5-bit counter (0..8 for 8 cycles processing 2 bits each)
    reg [2:0] booth_bits;             // 3 bits for Booth encoding

    // Function to compute partial product based on Booth encoding
    function signed [17:0] booth_decode;
        input [2:0] bits;
        input signed [15:0] mcand;
        reg signed [17:0] result;
        begin
            case (bits)
                3'b000, 3'b111: result = 18'sd0;           // 0
                3'b001, 3'b010: result = {mcand[15], mcand}; // +1 * mcand, 18-bit sign extended
                3'b101, 3'b110: result = -{mcand[15], mcand}; // -1 * mcand
                3'b011: result = {mcand[15], mcand} <<< 1;    // +2 * mcand
                3'b100: result = -({mcand[15], mcand} <<< 1); // -2 * mcand
                default: result = 18'sd0;
            endcase
            booth_decode = result;
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};
            // Append one zero bit at LSB for Booth encoding (multiplier_ext = {b, 0})
            multiplier_ext <= {b, 1'b0}; // 9 bits (actually 8+1)
            product <= 32'sd0;
            ctr <= 5'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            if (ctr < 5'd8) begin
                // Extract 3 bits from multiplier_ext for current Booth encoding
                // For iteration i: bits = multiplier_ext[2*ctr+1 : 2*ctr -1]
                // Handle 2*ctr-1 < 0 by zero-padding multiplier_ext LSB side
                // multiplier_ext is 9 bits: bits 0..8 (0 is appended zero)

                // Calculate indexes safely
                integer idx_upper, idx_middle, idx_lower;
                reg [2:0] bits_temp;
                begin
                    idx_upper = 2*ctr + 1;
                    idx_middle = 2*ctr;
                    idx_lower = 2*ctr - 1;

                    bits_temp[2] = (idx_upper <= 8) ? multiplier_ext[idx_upper] : 1'b0;
                    bits_temp[1] = (idx_middle <= 8) ? multiplier_ext[idx_middle] : 1'b0;
                    bits_temp[0] = (idx_lower >= 0 && idx_lower <= 8) ? multiplier_ext[idx_lower] : 1'b0;
                end
                booth_bits <= bits_temp;

                // Calculate partial product (18-bit) from booth decode
                // Shift partial product by 2*ctr bits because each iteration processes 2 bits
                // product is 32-bit signed, partial product shifted by 2*ctr positions
                reg signed [31:0] partial_prod;
                begin
                    partial_prod = booth_decode(booth_bits, multiplicand);
                    // Shift left by 2*ctr bits
                    partial_prod = partial_prod <<< (2*ctr);
                end

                // Accumulate partial product
                product <= product + partial_prod;

                ctr <= ctr + 1'b1;
                rdy <= 1'b0;
                p <= 16'd0;
            end else begin
                // Done: output result and set ready
                rdy <= 1'b1;
                p <= product[15:0];  // lower 16 bits as product output
            end
        end
    end

endmodule