module multi_booth_8bit(
    input wire clk,
    input wire reset,
    input wire [7:0] a,     // multiplicand
    input wire [7:0] b,     // multiplier
    output reg [15:0] p,
    output reg rdy
);
    // Internal registers
    reg signed [16:0] accumulator;     // 17 bits to hold partial product and shifted bits
    reg signed [16:0] multiplicand;    // sign-extended multiplicand (17 bits)
    reg [8:0] multiplier;              // 9 bits: 8 bits b + 1 extra LSB bit for Booth recoding

    reg [2:0] cycle; // 0 to 4 cycles (need 4 cycles for 8 bits with radix-4, 3 bits per booth code)

    // Booth recoding function: inputs 3 bits and outputs multiplier for multiplicand (-2,-1,0,1,2)
    function signed [1:0] booth_decode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000,
                3'b111: booth_decode = 2'd0;
                3'b001,
                3'b010: booth_decode =  2'd1;
                3'b011: booth_decode =  2'd2;
                3'b100: booth_decode = -2'd2;
                3'b101,
                3'b110: booth_decode = -2'd1;
                default: booth_decode = 0;
            endcase
        end
    endfunction

    // Partial product generation function: returns signed [16:0]
    // Input: multiplier code (-2..2), multiplicand 17-bit signed
    function signed [16:0] get_partial_product;
        input signed [1:0] code;
        input signed [16:0] mpcand;
        begin
            case (code)
                2'd0: get_partial_product = 17'd0;
                2'd1: get_partial_product = mpcand;
                2'd2: get_partial_product = mpcand <<< 1; // multiply by 2
                -2'd1: get_partial_product = -mpcand;
                -2'd2: get_partial_product = -(mpcand <<< 1);
                default: get_partial_product = 17'd0;
            endcase
        end
    endfunction

    reg signed [1:0] booth_code;
    reg signed [16:0] partial_prod;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, initialize registers
            // sign extend multiplicand and multiplier
            multiplicand <= {{9{a[7]}}, a};       // 8 bits + 9 bits sign extension = 17 bits
            multiplier   <= {b,1'b0};              // append zero bit at LSB for Booth radix-4 recoding
            accumulator  <= 17'd0;
            cycle        <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (cycle < 4) begin
                // Extract 3 bits from multiplier for current cycle booth code
                // bits: multiplier[2*cycle+1 : 2*cycle-1]
                // careful about indices:
                // For cycle=0 -> bits = multiplier[1: -1] but -1 invalid, so zero pad by design:
                // To avoid negative index, always safe because multiplier has 9 bits and we shift 2 bits per cycle
                // We'll extract bits [2*cycle+1 : 2*cycle-1], if negative index use zero
                
                // Create a 3-bit vector safely
                // For cycle=0, bits = {multiplier[1], multiplier[0], 0}
                // For cycle=1, bits = {multiplier[3], multiplier[2], multiplier[1]}
                // For cycle=2, bits = {multiplier[5], multiplier[4], multiplier[3]}
                // For cycle=3, bits = {multiplier[7], multiplier[6], multiplier[5]}
                // Use conditional to handle index <0 as zero
                
                reg [2:0] booth_bits;
                begin
                    booth_bits[2] = (2*cycle+1 <= 8) ? multiplier[2*cycle+1] : 1'b0;
                    booth_bits[1] = (2*cycle   <= 8) ? multiplier[2*cycle]   : 1'b0;
                    booth_bits[0] = (2*cycle-1 >= 0) ? multiplier[2*cycle-1] : 1'b0;
                    booth_code = booth_decode(booth_bits);
                end

                // Get partial product for this booth code
                partial_prod = get_partial_product(booth_code, multiplicand);

                // Add partial product shifted by 2*cycle bits to accumulator
                // Accumulator holds product shifted right accordingly:
                // Actually, in Booth radix-4, after adding partial product, shift multiplier right by 2 bits
                accumulator = accumulator + (partial_prod <<< (2*cycle));

                cycle <= cycle + 1'b1;
            end else begin
                // Finished all 4 cycles
                // Output product is lower 16 bits of accumulator
                p <= accumulator[15:0];
                rdy <= 1'b1;
            end
        end
    end
endmodule