module multi_booth_8bit (
    input            clk,
    input            reset,
    input      [7:0] a,     // multiplicand (signed)
    input      [7:0] b,     // multiplier (signed)
    output reg [15:0] p,    // product output
    output reg       rdy     // ready signal
);

    reg signed [8:0] multiplicand;     // 9-bit signed multiplicand (sign-extended)
    reg signed [8:0] multiplier;       // 9-bit signed multiplier with extra LSB zero bit for Booth recoding
    reg signed [17:0] accumulator;     // 18-bit signed accumulator for partial sums
    reg [2:0] step;                    // step counter: 0 to 5 (only 5 steps needed for 8-bit Radix-4)

    wire [2:0] booth_bits;
    reg signed [17:0] partial_product;

    assign booth_bits = multiplier[2:0];

    // Combinational partial product generator based on Booth recode bits
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 18'sd0;
            3'b001, 3'b010: partial_product = {{9{multiplicand[8]}}, multiplicand};          // +1 * multiplicand
            3'b011:         partial_product = {{8{multiplicand[8]}}, multiplicand, 1'b0};   // +2 * multiplicand
            3'b100:         partial_product = -({{8{multiplicand[8]}}, multiplicand, 1'b0}); // -2 * multiplicand
            3'b101, 3'b110: partial_product = -({{9{multiplicand[8]}}, multiplicand});       // -1 * multiplicand
            default:        partial_product = 18'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {a[7], a};           // sign-extend multiplicand to 9 bits
            multiplier   <= {b, 1'b0};           // multiplier with extra LSB zero bit
            accumulator  <= 18'sd0;
            step         <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (step < 3'd5) begin
                // Accumulate partial product shifted by 2*step (radix-4)
                accumulator <= accumulator + (partial_product <<< (2*step));
                // Arithmetic right shift multiplier by 2 bits with sign extension
                multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };
                step <= step + 1'b1;
            end
            if (step == 3'd4) begin
                // After final step, set output and ready flag
                p   <= accumulator[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule