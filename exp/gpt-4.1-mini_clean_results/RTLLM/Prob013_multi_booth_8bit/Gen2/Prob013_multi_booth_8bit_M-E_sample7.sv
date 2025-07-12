module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,      // multiplicand
    input wire [7:0] b,      // multiplier
    output reg [15:0] p,     // product output
    output reg rdy           // ready signal
);

    // Signed 16-bit multiplicand (sign-extended from input)
    reg signed [15:0] multiplicand;

    // Multiplier extended by 1 bit for Booth encoding (17 bits: 16 multiplier bits + appended zero)
    reg [16:0] booth_reg;

    // Accumulator register for partial sums, wider to handle shifts and adds
    reg signed [33:0] acc; // enough width: max shift is 6 bits (3 * 2) plus sign extension

    // 3-bit counter for four Radix-4 groups (each group processes 2 bits of multiplier)
    reg [2:0] count;

    // State machine states for clarity (optional)
    // Only 2 states: IDLE (waiting for reset) and BUSY (processing)
    reg busy;

    // Booth decoding function: decode 3 bits into signed partial product multiplier
    // Input: 3-bit booth group bits, multiplicand (signed 16-bit)
    // Output: signed 34-bit partial product (sufficient width for shifts)
    function signed [33:0] booth_decode;
        input [2:0] bits;
        input signed [15:0] m;
        reg signed [33:0] temp;
        begin
            case(bits)
                3'b000,
                3'b111: temp = 34'sd0;
                3'b001,
                3'b010: temp = {{18{m[15]}}, m};             // +1 * multiplicand
                3'b011: temp = ({{18{m[15]}}, m}) << 1;     // +2 * multiplicand (shift left 1)
                3'b100: temp = -(({{18{m[15]}}, m}) << 1);  // -2 * multiplicand
                3'b101,
                3'b110: temp = -({{18{m[15]}}, m});         // -1 * multiplicand
                default: temp = 34'sd0;                      // default case
            endcase
            booth_decode = temp;
        end
    endfunction

    // Extract 3 bits from booth_reg for current group:
    // booth_reg bit indexing: LSB at position 0
    // For iteration i = 0..3:
    // bits = booth_reg[2*i+1 : 2*i -1], with the -1 bit replaced by 0 if negative
    function [2:0] get_booth_bits;
        input integer idx;
        reg bit_minus_one;
        begin
            bit_minus_one = ( (2*idx) == 0 ) ? 1'b0 : booth_reg[2*idx - 1];
            get_booth_bits = { booth_reg[2*idx + 1], booth_reg[2*idx], bit_minus_one };
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs to 16 bits
            multiplicand <= { {8{a[7]}}, a };
            // Load multiplier into booth register with appended zero LSB
            booth_reg <= {b, 1'b0};
            acc <= 34'sd0;
            count <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
            busy <= 1'b1; // start processing after reset
        end else if (busy) begin
            if (count < 4) begin
                // Decode booth bits for current group
                // Using function to get bits
                reg [2:0] booth_bits;
                booth_bits = get_booth_bits(count);

                // Get partial product based on booth bits and multiplicand
                reg signed [33:0] pp;
                pp = booth_decode(booth_bits, multiplicand);

                // Shift partial product by 2*count bits (Radix-4 steps)
                acc <= acc + (pp << (2*count));

                // Increment counter
                count <= count + 1'b1;
            end else begin
                // All 4 groups processed: output product and set ready
                p <= acc[15:0];   // lower 16 bits contain the final product
                rdy <= 1'b1;
                busy <= 1'b0;     // done
            end
        end
    end

endmodule