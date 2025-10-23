module multi_booth_8bit (
    input  wire         clk,
    input  wire         reset,
    input  wire [7:0]   a,    // multiplicand
    input  wire [7:0]   b,    // multiplier
    output reg  [15:0]  p,
    output reg          rdy
);

    // Internal registers
    reg signed [15:0] multiplicand;    // sign-extended multiplicand
    reg [8:0]         multiplier_ext;  // multiplier extended with one 0 LSB for Booth encoding: 8+1 = 9 bits
    reg [2:0]         cycle_count;     // 0..4, counts Radix-4 Booth cycles (each handles 2 bits)
    reg signed [33:0] accumulator;     // accumulator wide enough to hold all shifted partial sums safely

    // Registers used for intermediate processing
    reg [2:0] booth_bits;               // 3 bits for Booth encoding input
    reg signed [17:0] partial_product; // partial product (±2 * multiplicand), 18 bits wide for shifts and sign extension

    // Booth decoding function:
    // Input: 3 bits representing multiplier bits (Y_{2i+1}, Y_{2i}, Y_{2i-1})
    // Output: signed partial product (multiplicand * multiplier factor)
    function signed [17:0] booth_decode;
        input [2:0] bits;
        input signed [15:0] m;
        begin
            case (bits)
                3'b000,
                3'b111: booth_decode = 18'sd0;                               // 0
                3'b001,
                3'b010: booth_decode = { {2{m[15]}}, m };                   // +1 * multiplicand
                3'b011: booth_decode = { {1{m[15]}}, m, 1'b0 };             // +2 * multiplicand (shift left 1)
                3'b100: booth_decode = -({ {1{m[15]}}, m, 1'b0 });          // -2 * multiplicand
                3'b101,
                3'b110: booth_decode = -({ {2{m[15]}}, m });                // -1 * multiplicand
                default: booth_decode = 18'sd0;                             // safe default
            endcase
        end
    endfunction

    // Extract Booth bits function: extracts 3 bits (current group) from multiplier_ext for given cycle
    // Handles edge cases by zero-padding
    // For cycle i: bits [2*i+1, 2*i, 2*i-1], if (2*i-1)<0 then zero-pad lower bit.
    function [2:0] get_booth_bits;
        input [8:0] m_ext;
        input [2:0] i;
        reg bit_minus_1;
        begin
            if ((2*i) == 0)
                bit_minus_1 = 1'b0;
            else
                bit_minus_1 = m_ext[2*i - 1];
            get_booth_bits = { m_ext[2*i + 1], m_ext[2*i], bit_minus_1 };
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend multiplicand from 8 to 16 bits
            multiplicand  <= {{8{a[7]}}, a};
            // Extend multiplier with one 0 bit at LSB
            multiplier_ext <= {b, 1'b0};
            cycle_count <= 3'd0;
            accumulator <= 34'sd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (cycle_count < 3'd4) begin
                // Get Booth bits for current cycle
                booth_bits <= get_booth_bits(multiplier_ext, cycle_count);

                // Decode partial product based on Booth bits and multiplicand
                partial_product <= booth_decode(booth_bits, multiplicand);

                // Accumulate partial product shifted by 2*cycle_count bits
                accumulator <= accumulator + (partial_product <<< (2 * cycle_count));

                // Increment cycle count
                cycle_count <= cycle_count + 1'b1;
            end else begin
                // After 4 cycles, set output product and ready flag
                p <= accumulator[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule