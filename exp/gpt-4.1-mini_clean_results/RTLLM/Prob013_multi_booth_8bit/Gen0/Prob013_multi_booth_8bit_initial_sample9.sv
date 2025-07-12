module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,  // multiplicand
    input [7:0] b,  // multiplier
    output reg [15:0] p,
    output reg rdy
);

    reg [16:0] multiplier;   // multiplier extended with 1 zero bit at LSB for booth recoding
    reg [15:0] multiplicand; // sign extended multiplicand
    reg signed [16:0] acc;   // accumulator: extended product register (signed)
    reg [2:0] booth_bits;    // 3 bits for booth encoding (current 2 bits + previous bit)
    reg [2:0] ctr;           // 3-bit counter, counts up to 4 for 4 cycles (Radix-4 for 8 bit)
    
    // Function to get booth operation code from 3 bits
    // booth_bits encoding:
    // 000 -> 0, 001 -> +1, 010 -> +1, 011 -> +2, 100 -> -2, 101 -> -1, 110 -> -1, 111 -> 0
    // Map:
    // 0: no operation
    // 1: add multiplicand
    // 2: add 2*multiplicand
    // -1: subtract multiplicand
    // -2: subtract 2*multiplicand
    function signed [2:0] booth_dec;
        input [2:0] bits;
        begin
            case (bits)
                3'b000,
                3'b111: booth_dec = 0;
                3'b001,
                3'b010: booth_dec = 1;
                3'b011: booth_dec = 2;
                3'b100: booth_dec = -2;
                3'b101,
                3'b110: booth_dec = -1;
                default: booth_dec = 0;
            endcase
        end
    endfunction

    // On reset:
    // multiplicand = sign extend a to 16 bits
    // multiplier = b extended with 0 at LSB to 17 bits
    // accumulator = 0
    // counter = 0
    // ready = 0
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};         // sign extend multiplicand
            multiplier <= {b, 1'b0};                // multiplier + appended 0 bit
            acc <= 17'sd0;
            ctr <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            if (ctr < 4) begin
                // Get current 3 bits for booth encoding: bits at positions [1:0] and previous bit [2]
                // multiplier[1:0] current bits, multiplier[2] previous bit (shifted)
                booth_bits = multiplier[2:0];

                // Decode booth bits to control code
                case (booth_dec(booth_bits))
                    3'd2: acc = acc + (multiplicand <<< 1);    // +2*multiplicand
                    3'd1: acc = acc + multiplicand;             // +1*multiplicand
                    -3'd1: acc = acc - multiplicand;            // -1*multiplicand
                    -3'd2: acc = acc - (multiplicand <<< 1);   // -2*multiplicand
                    default: acc = acc;                          // 0 no operation
                endcase

                // Arithmetic right shift acc and multiplier combined by 2 bits
                // Prepare combined 33-bit value {acc, multiplier} to shift right 2 bits arithmetically
                // acc is 17 bits signed, multiplier 17 bits unsigned (LSB)
                // Combine:
                //   acc [16:0]
                //   multiplier [16:0]
                // After shifting right 2 bits, update acc and multiplier

                {acc, multiplier} = {acc, multiplier} >>> 2;

                ctr <= ctr + 1'b1;
                if (ctr == 3'd3) begin
                    // After final cycle, assign product and set ready
                    p <= acc[15:0]; // lower 16 bits of acc is product
                    rdy <= 1'b1;
                end
            end
        end
    end

endmodule