module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand;      // sign-extended multiplicand
    reg signed [16:0] multiplier_reg;    // sign-extended multiplier + appended zero bit for Booth (9 bits)
    reg signed [31:0] accumulator;       // accumulator (wider to avoid overflow)
    reg [4:0]         ctr;               // 5-bit counter (only 4 cycles needed for 8-bit radix-4)
    
    reg signed [2:0]  booth_bits;        // 3 bits for Booth encoding
    reg signed [1:0]  booth_factor;      // Booth multiplication factor (-2..2)

    // Booth decoding function (combinational)
    always @(*) begin
        // extract the 3 bits for Booth encoding: multiplier_reg[1:0] and the previous LSB multiplier_reg[0]'s previous bit (simulated by appended zero bit)
        booth_bits = {multiplier_reg[1:0], multiplier_reg[0] & 1'b0}; // Here multiplier_reg[0] & 1'b0=0 effectively appends zero bit as LSB

        // Actually, proper extraction is multiplier_reg[2:0], because we have multiplier_reg shifted appropriately:
        // So override booth_bits by multiplier_reg[2:0]
    end

    // We'll fix this in logic to correctly extract multiplier_reg[2:0]

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, sign-extend inputs and initialize registers
            multiplicand   <= {{8{a[7]}}, a};         // 16-bit sign-extended multiplicand
            multiplier_reg <= {{8{b[7]}}, b, 1'b0};   // 9-bit multiplier + appended zero for Booth
            accumulator    <= 0;
            ctr            <= 0;
            p              <= 0;
            rdy            <= 0;
        end else if (!rdy) begin
            // Extract the 3 bits for Booth encoding from multiplier_reg[2:0]
            booth_bits = multiplier_reg[2:0];

            // Decode Booth factor
            case (booth_bits)
                3'b000,
                3'b111: booth_factor = 2'sd0;
                3'b001,
                3'b010: booth_factor = 2'sd1;
                3'b011: booth_factor = 2'sd2;
                3'b100: booth_factor = -2;
                3'b101,
                3'b110: booth_factor = -1;
                default: booth_factor = 2'sd0;
            endcase

            // Add or subtract multiplicand * factor shifted by 2*ctr to accumulator
            // multiplicand is 16-bit signed, accumulator 32-bit signed
            case (booth_factor)
                2'sd0: ; // no operation
                2'sd1: accumulator <= accumulator + (multiplicand <<< (2 * ctr));
                2'sd2: accumulator <= accumulator + ((multiplicand <<< 1) <<< (2 * ctr)); // 2 * multiplicand shifted by 2*ctr
               -2'sd1: accumulator <= accumulator - (multiplicand <<< (2 * ctr));
               -2'sd2: accumulator <= accumulator - ((multiplicand <<< 1) <<< (2 * ctr));
                default: ;
            endcase

            // Shift multiplier_reg right arithmetic by 2 bits to process next Booth bits in next cycle
            // Since multiplier_reg is signed, use arithmetic shift right
            multiplier_reg <= $signed(multiplier_reg) >>> 2;

            // Increment cycle counter
            ctr <= ctr + 1;

            if (ctr == 4) begin
                // Completed 4 cycles (8 bits processed)
                p <= accumulator[15:0]; // output lower 16 bits
                rdy <= 1;
            end
        end
    end

endmodule