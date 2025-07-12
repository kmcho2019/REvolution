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
    reg signed [9:0]  multiplier;    // multiplier extended with appended zero bit (8 bits + 2 zeros for safe radix-4)
    reg signed [26:0] product;       // accumulator register (enough width for shifts and sums)
    reg [3:0]         count;         // cycle counter, counts 0 to 7 (8 cycles total)
    reg signed [2:0]  factor;        // Booth factor (-2..2)

    // Booth decoding function
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_decode = 3'sd0;
                3'b001, 3'b010: booth_decode = 3'sd1;
                3'b011:         booth_decode = 3'sd2;
                3'b100:         booth_decode = -3'sd2;
                3'b101, 3'b110: booth_decode = -3'sd1;
                default:        booth_decode = 3'sd0;
            endcase
        end
    endfunction

    wire signed [16:0] multiplicand_shifted1 = multiplicand <<< 1;

    wire signed [26:0] partial;
    assign partial = (factor ==  3'sd0) ? 27'sd0 :
                     (factor ==  3'sd1) ? {{10{multiplicand[16]}}, multiplicand} :
                     (factor ==  3'sd2) ? {{9{multiplicand_shifted1[16]}}, multiplicand_shifted1} :
                     (factor == -3'sd1) ? -{{10{multiplicand[16]}}, multiplicand} :
                     (factor == -3'sd2) ? -{{9{multiplicand_shifted1[16]}}, multiplicand_shifted1} :
                     27'sd0;

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= { {9{a[7]}}, a };
            multiplier   <= {b, 2'b00};   // Append 2 zeros for radix-4
            product      <= 27'sd0;
            count        <= 4'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
            factor       <= 3'sd0;
        end else if (!rdy) begin
            factor <= booth_decode(multiplier[2:0]);
            // Add partial multiple to product
            product <= (product >>> 2) + partial;
            // Arithmetic shift multiplier right by 2 bits for next step
            multiplier <= multiplier >>> 2;
            count <= count + 1'b1;
            if (count == 4'd7) begin
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end else begin
            // Hold ready until reset
            rdy <= 1'b1;
        end
    end

endmodule