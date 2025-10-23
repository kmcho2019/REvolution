module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,   // multiplicand
    input      [7:0]  b,   // multiplier
    output reg [15:0] p,   // product
    output reg        rdy   // ready signal
);

    // Registers for multiplication process
    reg signed [15:0] multiplicand;
    reg signed [15:0] product;
    reg [15:0] multiplier; // unsigned shifting for multiplier bits

    reg [2:0] cycle_cnt;   // We need 4 cycles (0 to 3) for radix-4 (processing 2 bits each cycle)

    // Function to decode Radix-4 Booth code (3 bits: [bit+1 bit 0 bit-1]) derived from multiplier bits with extra bit
    // Since we only have multiplier 8 bits, we'll add a trailing zero bit for encoding
    // We'll build the 3-bit group each cycle: [next multiplier bit, current bit, previous bit]
    // For implementation simplicity, we use 3 bits from multiplier plus a trailing zero bit.
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 3'sd0;
                3'b001, 3'b010: booth_decode = 3'sd1;
                3'b011:         booth_decode = 3'sd2;
                3'b100:         booth_decode = -3'sd2;
                3'b101, 3'b110: booth_decode = -3'sd1;
                default:        booth_decode = 3'sd0;
            endcase
        end
    endfunction

    reg [9:0] extended_multiplier; // 8 bits multiplier + 2 trailing zero bits for safe radix-4 coding

    always @(posedge clk) begin
        if (reset) begin
            multiplicand      <= {{8{a[7]}}, a}; // sign-extend multiplicand
            product           <= 16'sd0;
            multiplier        <= 16'd0;
            extended_multiplier<= {b, 2'b00}; // zero-extend multiplier by 2 bits for radix-4 encoding
            cycle_cnt         <= 3'd0;
            p                 <= 16'd0;
            rdy               <= 1'b0;
        end else if (!rdy) begin
            if (cycle_cnt < 3'd4) begin
                // Extract 3 bits for Booth encoding: bits [2+2*cycle_cnt : 0+2*cycle_cnt]
                // For cycle_cnt=0, bits 2:0, cycle_cnt=1 bits 4:2, etc.
                // To simplify, shift extended_multiplier right by 2*cycle_cnt bits
                reg [2:0] booth_bits;
                booth_bits = extended_multiplier[2 + 2*cycle_cnt -: 3];

                // Decode multiplier bits according to Radix-4 Booth
                reg signed [2:0] mult_factor;
                mult_factor = booth_decode(booth_bits);

                // Calculate the additive term: multiplicand * mult_factor
                reg signed [17:0] term; // wider for 2x multiplicand cases
                term = multiplicand * mult_factor;

                // Shift term left by 2*cycle_cnt bits because partial product aligns with multiplier position
                term = term <<< (2*cycle_cnt);

                // Accumulate partial product
                product <= product + term;

                cycle_cnt <= cycle_cnt + 1'b1;
            end else begin
                // Done multiplication
                p <= product;
                rdy <= 1'b1;
            end
        end
    end

endmodule