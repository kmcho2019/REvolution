module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,      // multiplicand
    input  wire [7:0]  b,      // multiplier
    output reg  [15:0] p,      // product output
    output reg         rdy      // ready signal
);

    // Extended multiplicand and multiplier registers
    reg signed [16:0] multiplicand;   // 17-bit signed (16 bits plus sign)
    reg signed [16:0] multiplier;     // 17-bit signed (multiplier + 1 zero bit appended at LSB)

    // Accumulator wide enough to hold result plus guard bits (25 bits)
    reg signed [24:0] accumulator;

    reg [2:0] ctr;    // 3-bit counter: 0 to 4 cycles needed (only 4 cycles for radix-4)
    
    // Radix-4 Booth encoding function (based on 3 bits):
    // Booth encoding rules:
    // bits [2:0] => operation:
    // 000 =>  0
    // 001 => +1 * multiplicand
    // 010 => +1 * multiplicand
    // 011 => +2 * multiplicand
    // 100 => -2 * multiplicand
    // 101 => -1 * multiplicand
    // 110 => -1 * multiplicand
    // 111 =>  0

    wire [2:0] booth_bits = multiplier[2:0];
    reg signed [24:0] partial_product;

    always @(*) begin
        case (booth_bits)
            3'b000,
            3'b111: partial_product = 25'sd0;
            3'b001,
            3'b010: partial_product = {{8{multiplicand[16]}}, multiplicand};          // +1 * multiplicand
            3'b011: partial_product = {{8{multiplicand[16]}}, multiplicand} << 1;     // +2 * multiplicand
            3'b100: partial_product = -({{8{multiplicand[16]}}, multiplicand} << 1);  // -2 * multiplicand
            3'b101,
            3'b110: partial_product = -{{8{multiplicand[16]}}, multiplicand};         // -1 * multiplicand
            default: partial_product = 25'sd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // sign extend multiplicand to 17 bits
            multiplicand <= {{9{a[7]}}, a};  // 8 bits to 17 bits sign extended
            // multiplicand width: 17 bits (to allow shifts)

            // multiplier extended by one zero bit at LSB
            multiplier <= {{8{b[7]}}, b, 1'b0}; // 8 bits plus appended 0 bit for radix-4 booth

            accumulator <= 25'sd0;
            ctr <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 3'd4) begin
                // Add partial product aligned with current position (2 bits per iteration)
                accumulator <= (accumulator >>> 2) + partial_product;
                // Shift multiplier right arithmetically by 2 bits to prepare next booth bits
                multiplier <= multiplier >>> 2;
                ctr <= ctr + 1;
            end else begin
                p <= accumulator[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule