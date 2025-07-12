module multi_booth_8bit (
    input          clk,
    input          reset,
    input  [7:0]   a,    // multiplicand (signed)
    input  [7:0]   b,    // multiplier (signed)
    output reg [15:0] p, // product output
    output reg      rdy   // ready signal
);

    // Signed versions of inputs for proper sign extension
    wire signed [8:0] multiplicand = {a[7], a};   // 9-bit signed multiplicand
    reg signed [8:0] multiplier;                   // 9-bit signed multiplier with appended 0 bit

    reg signed [17:0] accumulator;  // 18-bit signed accumulator for partial sums
    reg [2:0] step;                 // 0 to 4 step counter (5 cycles)

    wire [2:0] booth_bits = multiplier[2:0]; // current 3 LSBs of multiplier

    // Combinational partial product based on radix-4 Booth encoding
    reg signed [17:0] partial_product;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 18'sd0;
            3'b001, 3'b010: partial_product = {{9{multiplicand[8]}}, multiplicand};           // +1 * multiplicand
            3'b011:         partial_product = {{8{multiplicand[8]}}, multiplicand, 1'b0};    // +2 * multiplicand (shift left 1)
            3'b100:         partial_product = -({{8{multiplicand[8]}}, multiplicand, 1'b0}); // -2 * multiplicand
            3'b101, 3'b110: partial_product = -({{9{multiplicand[8]}}, multiplicand});       // -1 * multiplicand
            default:        partial_product = 18'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplier <= {b, 1'b0};  // Append 0 bit to multiplier for Booth recoding
            accumulator <= 18'sd0;
            step <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (step < 5) begin
            // Update accumulator only if partial_product is not zero (clock gating effect)
            if (partial_product != 18'sd0)
                accumulator <= accumulator + (partial_product <<< (2*step));
            // Arithmetic shift right multiplier by 2 bits
            multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };
            step <= step + 1'b1;
            rdy <= 1'b0;
        end else begin
            // After 5 steps, output result and assert ready
            p <= accumulator[15:0];
            rdy <= 1'b1;
            // Hold values stable until next reset
        end
    end

endmodule