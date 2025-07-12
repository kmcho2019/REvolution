module multi_booth_8bit (
    input           clk,
    input           reset,
    input   [7:0]   a,      // multiplicand
    input   [7:0]   b,      // multiplier
    output reg [15:0] p,    // product output
    output reg      rdy      // ready flag
);

    // Internal registers
    reg signed [16:0] multiplicand;  // sign-extended multiplicand (8 bits + 9 bits extension)
    reg signed [8:0]  multiplier;    // multiplier extended with appended zero bit
    reg signed [24:0] product;       // accumulator register (large enough for partial sums)
    reg [3:0]         count;         // cycle counter, counts 0 to 7 (8 cycles total)

    // Booth decoding function: input 3 bits, output -2, -1, 0, 1, or 2 as signed value
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            // Radix-4 Booth recoding table:
            // bits: y2 y1 y0 (y2 = MSB)
            case(bits)
                3'b000, 3'b111: booth_decode = 3'sd0;   // 0
                3'b001, 3'b010: booth_decode = 3'sd1;   // +1
                3'b011:          booth_decode = 3'sd2;   // +2
                3'b100:          booth_decode = -3'sd2;  // -2
                3'b101, 3'b110: booth_decode = -3'sd1;  // -1
                default:         booth_decode = 3'sd0;
            endcase
        end
    endfunction

    // Partial multiple of multiplicand based on factor (-2 to 2)
    wire signed [16:0] partial_multiple;
    reg  signed [2:0]  factor;

    assign partial_multiple = (factor ==  3'sd0) ? 17'sd0 :
                              (factor ==  3'sd1) ? multiplicand :
                              (factor ==  3'sd2) ? (multiplicand <<< 1) :
                              (factor == -3'sd1) ? -multiplicand :
                              (factor == -3'sd2) ? -(multiplicand <<< 1) : 17'sd0;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, load sign-extended multiplicand and multiplier,
            // clear product, counter and ready.
            multiplicand <= { {9{a[7]}}, a }; // sign-extend a (multiplicand) to 17 bits
            multiplier   <= {b, 1'b0};         // append 0 bit at LSB to multiplier
            product      <= 25'sd0;
            count        <= 4'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
            factor       <= 3'sd0;
        end else if (!rdy) begin
            // Each cycle perform one radix-4 Booth step
            factor <= booth_decode(multiplier[2:0]);

            // Accumulate partial product
            product <= product + (partial_multiple <<< (2 * count));

            // Shift multiplier right by 2 bits for next recoding
            multiplier <= multiplier >>> 2;

            // Increment cycle count
            count <= count + 1'b1;

            // When count reaches 8, multiplication is done
            if (count == 4'd7) begin
                p <= product[15:0];  // Output lower 16 bits as product
                rdy <= 1'b1;         // Assert ready signal
            end
        end else begin
            // Hold ready high until next reset
            rdy <= 1'b1;
        end
    end

endmodule