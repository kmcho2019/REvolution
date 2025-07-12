module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,    // multiplicand
    input  [7:0]    b,    // multiplier
    output reg [15:0] p,   // product
    output reg       rdy
);

    // Registers
    reg signed [15:0] multiplicand; // sign-extended multiplicand, shifted left during iterations
    reg signed [16:0] multiplier;   // multiplier bits with an extra LSB zero bit for Booth decoding
    reg signed [33:0] accumulator;  // wider accumulator to hold intermediate sums
    reg [4:0] ctr;                  // 5-bit counter (0..16)

    // Extract Booth bits: Current bit and previous bit for Booth radix-4 code
    // bit_minus_one is 0 for ctr=0 to emulate extra 0 bit at LSB
    wire bit_0 = multiplier[ctr];
    wire bit_minus_one = (ctr == 0) ? 1'b0 : multiplier[ctr-1];

    // Booth code: 
    // 00 or 11 -> 0
    // 01 -> +multiplicand
    // 10 -> -multiplicand
    // Radix-4 extended to multiply by +2 and -2 by looking at 3 bits, but here per problem we process one bit per cycle
    // Since problem states multiplier[ctr] only, we will process one bit at a time and shift multiplicand accordingly.
    // But problem says Radix-4 Booth multiplier, so let's take groups of 2 bits per cycle:
    // For that, process multiplier bits [ctr+1: ctr-1] with 3 bits. Here, ctr counts from 0 to 15,
    // but as per problem, counter from 0 to 15 with 16 cycles.

    // To implement Radix-4 Booth logic we need 3 bits: y_{2i+1}, y_{2i}, y_{2i-1}
    // Let's compute current Booth group bits for each cycle:
    wire [2:0] booth_bits;
    // For ctr 0..15, extract bits at positions ctr+1, ctr, ctr-1 of multiplier
    // ctr+1 can be beyond 16, so we treat beyond 16 as 0.
    // multiplicand and multiplier are signed 16 and 17 bits respectively
    // multiplier is 17 bits: bits 16 down to 0

    // Extend multiplier to 18 bits with 0 at MSB for safe indexing
    wire [17:0] multiplier_ext = {1'b0, multiplier};

    // booth_bits = {y_{ctr+1}, y_{ctr}, y_{ctr-1}}
    // For ctr==15, y_{ctr+1} = bit 16 in multiplier_ext, safe indexing
    assign booth_bits = { multiplier_ext[ctr+1], multiplier_ext[ctr], (ctr==0) ? 1'b0 : multiplier_ext[ctr-1] };

    reg signed [33:0] addend; // Value to add to accumulator based on Booth encoding

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};  // sign-extend a (multiplicand)
            multiplier   <= {b, 1'b0};        // multiplier with appended zero at LSB for Booth encoding
            accumulator  <= 0;
            ctr          <= 0;
            rdy          <= 0;
            p            <= 0;
        end else if (!rdy) begin
            // Decode booth_bits to decide addend
            case (booth_bits)
                3'b000,
                3'b111: addend <= 0;
                3'b001,
                3'b010: addend <= {{18{multiplicand[15]}}, multiplicand};         // +1 * multiplicand shifted accordingly
                3'b011: addend <= {{17{multiplicand[15]}}, multiplicand, 1'b0};  // +2 * multiplicand (shift left by 1)
                3'b100: addend <= -({{17{multiplicand[15]}}, multiplicand, 1'b0}); // -2 * multiplicand
                3'b101,
                3'b110: addend <= -({{18{multiplicand[15]}}, multiplicand});     // -1 * multiplicand
                default: addend <= 0;
            endcase

            // Accumulate and shift multiplicand left by 2 for next group
            accumulator <= accumulator + (addend << (ctr * 2)); // shift addend by 2*ctr bits to align
            ctr <= ctr + 1;

            if (ctr == 15) begin
                rdy <= 1;
                // Output lower 16 bits of accumulator as product
                p <= accumulator[15:0];
            end
        end else begin
            // Hold output stable
            rdy <= rdy;
            p <= p;
            accumulator <= accumulator;
            multiplicand <= multiplicand;
            multiplier <= multiplier;
            ctr <= ctr;
        end
    end

endmodule