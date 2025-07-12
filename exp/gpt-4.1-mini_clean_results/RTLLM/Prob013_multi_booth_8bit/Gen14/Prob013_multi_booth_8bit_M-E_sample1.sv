module multi_booth_8bit (
    input           clk,
    input           reset,
    input   [7:0]   a,       // multiplicand
    input   [7:0]   b,       // multiplier
    output reg [15:0] p,     // product output
    output reg      rdy       // ready flag
);

    // Internal signals and registers
    reg signed [16:0] multiplicand;       // sign-extended multiplicand (17 bits)
    reg signed [32:0] accum;               // {accumulator(17 bits) | multiplier(16 bits) | 1-bit zero} = 34 bits
                                           // but using 33 bits: upper 17 bits accumulator, lower 16 bits multiplier + 1 bit
                                           // So total width = 17+16+1=34, but 33 bits used for accumulator and multiplier+bit
                                           // We'll use 33 bits: 17 accumulator bits + 16 multiplier bits + appended 1 bit
    reg [3:0] ctr;                        // 4-bit counter: 0 to 8 (8 cycles, since 16 bits / 2 bits per cycle)

    wire [2:0] booth_bits;                // lowest 3 bits of accum for Booth encoding

    // Extract the three bits for Booth recoding from accum[2:0]
    assign booth_bits = accum[2:0];

    // Booth decoding: returns signed factor -2 to +2
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 3'd0;     // 0
                3'b001, 3'b010: booth_decode = 3'd1;     // +1
                3'b011:          booth_decode = 3'd2;     // +2
                3'b100:          booth_decode = -3'd2;    // -2
                3'b101, 3'b110: booth_decode = -3'd1;    // -1
                default:         booth_decode = 3'd0;     // safety default 0
            endcase
        end
    endfunction

    // Next accumulator value calculation
    reg signed [16:0] acc_upper;         // upper 17 bits accumulator (signed)
    reg signed [16:0] acc_new;           // updated accumulator upper bits after addition

    reg signed [16:0] mplier;            // lower 17 bits multiplier+bit (but only read as unsigned in shifts)
    reg signed [16:0] multiplicand_factor; // multiplicand * factor (-2..2)

    reg signed [32:0] accum_next;        // next accum value after addition and shifting

    wire signed [2:0] factor;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs
            multiplicand <= {a[7], a, 8'b0} >> 8; // sign-extend a from 8 bits to 17 bits
            // This sign-extends by replicating MSB of a to upper bits:
            // method: {a[7], a} = 9 bits, then shift right 8 to get 17 bits with sign
            // Alternatively:
            // multiplicand <= {{9{a[7]}}, a}; but that is 17 bits total (9 +8).
            // Let's do: multiplicand <= {{9{a[7]}}, a}; simple and correct
            multiplicand <= {{9{a[7]}}, a};

            // accum <= accumulator(17 bits)=0, multiplier(16 bits)=b, appended bit=0
            // so accum = {17'b0, b (16 bits), 1'b0} total 34 bits, but declared as 33 bits here,
            // so just assign 33 bits as: {17'b0, b, 1'b0}
            accum <= {17'b0, b, 1'b0};

            ctr <= 0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else if (ctr < 4'd8) begin
            // Decode booth bits
            // factor = booth_decode(booth_bits)
            // Add multiplicand * factor to accumulator upper bits

            // Extract accumulator upper bits (17 bits signed)
            acc_upper = accum[32:16];

            // Compute factor
            factor = booth_decode(booth_bits);

            // Compute multiplicand * factor
            case (factor)
                3'd0, -3'd0: multiplicand_factor = 17'sd0;
                3'd1: multiplicand_factor = multiplicand;
                3'd2: multiplicand_factor = multiplicand <<< 1;
                -3'd1: multiplicand_factor = -multiplicand;
                -3'd2: multiplicand_factor = -(multiplicand <<< 1);
                default: multiplicand_factor = 17'sd0;
            endcase

            // Add partial product to accumulator upper bits
            acc_new = acc_upper + multiplicand_factor;

            // Compose new accum before shift
            accum_next = {acc_new, accum[15:0]};

            // Arithmetic right shift by 2 bits (signed) for entire accum register (33 bits)
            // Right shift by 2 bits, arithmetic: sign bit is acc_new[16]
            // So fill with acc_new[16] after shift
            accum <= { {2{acc_new[16]}}, accum_next[32:2] };

            ctr <= ctr + 1;

            // If last iteration, output product and set ready
            if (ctr == 4'd7) begin
                // The product is upper 16 bits of accumulator after last shift
                // accum[32:17] is accumulator upper 16 bits (ignoring LSB 1 bit)
                // Because accum is 33 bits: [32:16] upper 17 bits accumulator
                // We output bits [32:17] = 16 bits
                p <= accum[32:17];
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;
            end
        end else begin
            // Hold output and ready when done
            rdy <= 1'b1;
        end
    end

endmodule