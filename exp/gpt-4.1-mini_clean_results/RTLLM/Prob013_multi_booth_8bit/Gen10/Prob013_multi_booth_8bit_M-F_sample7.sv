module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // Number of Radix-4 cycles needed for 8-bit multiplier: 4 cycles (2 bits per cycle)
    localparam TOTAL_CYCLES = 4;

    // Sign-extended multiplicand and multiplier registers
    reg signed [15:0] multiplicand;         // 16-bit sign-extended multiplicand
    reg signed [16:0] multiplier_reg;       // 17-bit multiplier + appended zero bit for Booth encoding

    // Accumulator: 32 bits to hold intermediate sums safely
    reg signed [31:0] accumulator;

    // 3-bit cycle counter (0 to 3)
    reg [2:0] ctr;

    wire [2:0] booth_bits;
    wire signed [2:0] booth_factor;

    // Extract Booth bits (lowest 3 bits of multiplier_reg)
    assign booth_bits = multiplier_reg[2:0];

    // Booth factor decoding via function for cleaner and optimized logic
    function signed [2:0] booth_decode(input [2:0] bits);
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 3'sd0;
                3'b001, 3'b010: booth_decode = 3'sd1;
                3'b011:         booth_decode = 3'sd2;
                3'b100:         booth_decode = -3'sd2;
                3'b101, 3'b110: booth_decode = -3'sd1;
                default:        booth_decode = 3'sd0; // should never occur
            endcase
        end
    endfunction

    assign booth_factor = booth_decode(booth_bits);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand   <= {{8{a[7]}}, a};          // sign-extend multiplicand to 16 bits once
            multiplier_reg <= {{8{b[7]}}, b, 1'b0};    // multiplier + appended zero bit (17 bits)
            accumulator    <= 32'sd0;
            ctr            <= 3'd0;
            p              <= 16'd0;
            rdy            <= 1'b0;
        end else if (!rdy) begin
            // Perform Radix-4 Booth multiply steps while not ready
            // Only update accumulator if booth_factor != 0 to reduce switching
            if (booth_factor != 3'sd0) begin
                case (booth_factor)
                    3'sd1:  accumulator <= accumulator + {{16{multiplicand[15]}}, multiplicand};
                    3'sd2:  accumulator <= accumulator + ({{16{multiplicand[15]}}, multiplicand} <<< 1);
                    -3'sd1: accumulator <= accumulator - {{16{multiplicand[15]}}, multiplicand};
                    -3'sd2: accumulator <= accumulator - ({{16{multiplicand[15]}}, multiplicand} <<< 1);
                    default: accumulator <= accumulator; // no change
                endcase
            end

            // Arithmetic right shift multiplier_reg by 2 bits with sign extension
            // Concatenate: sign bit + upper bits shifted right by 2
            multiplier_reg <= {multiplier_reg[16], multiplier_reg[16:2]};

            ctr <= ctr + 3'd1;

            if (ctr == TOTAL_CYCLES - 1) begin
                // Last cycle complete, output product and set ready
                p <= accumulator[15:0];
                rdy <= 1'b1;
            end
        end
        // else retain p and rdy as output and stable
    end

endmodule