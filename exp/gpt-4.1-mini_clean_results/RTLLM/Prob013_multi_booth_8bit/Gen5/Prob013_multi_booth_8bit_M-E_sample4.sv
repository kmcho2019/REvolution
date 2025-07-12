module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,   // multiplicand
    input  wire [7:0]  b,   // multiplier
    output reg  [15:0] p,   // product output
    output reg         rdy   // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand;    // sign-extended multiplicand
    reg signed [15:0] multiplicand_x2; // 2 * multiplicand
    reg signed [16:0] multiplier_reg;  // multiplier with appended zero LSB (total 9 bits + sign ext)
    reg signed [31:0] accumulator;     // accumulator to hold intermediate sums
    reg [2:0]         cycle_cnt;       // 0 to 4 (4 cycles for radix-4 8-bit multiplication)

    wire [2:0] booth_bits;  // 3 bits for Booth encoding (multiplier_reg[1:0] and LSB zero appended)
    reg signed [2:0] booth_factor;

    // Extract 3 bits from multiplier register for Booth decoding: bits [1:0] + appended 0
    assign booth_bits = {multiplier_reg[1], multiplier_reg[0], 1'b0};

    // Booth encoding decoding logic for radix-4
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_factor = 0;
            3'b001, 3'b010: booth_factor =  1;
            3'b011:         booth_factor =  2;
            3'b100:         booth_factor = -2;
            3'b101, 3'b110: booth_factor = -1;
            default:        booth_factor =  0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs
            multiplicand    <= {{8{a[7]}}, a};
            multiplicand_x2 <= {{8{a[7]}}, a} <<< 1; // 2 * multiplicand precomputed
            // Sign-extend multiplier and append 1 zero bit (LSB)
            multiplier_reg  <= {{8{b[7]}}, b, 1'b0};
            accumulator     <= 0;
            cycle_cnt       <= 0;
            p               <= 0;
            rdy             <= 0;
        end else if (!rdy) begin
            // Add/subtract based on booth_factor and current cycle count (shifted by 2*cycle)
            case (booth_factor)
                3'sd0: ; // no operation
                3'sd1: accumulator <= accumulator + (multiplicand << (2*cycle_cnt));
                3'sd2: accumulator <= accumulator + (multiplicand_x2 << (2*cycle_cnt));
               -3'sd1: accumulator <= accumulator - (multiplicand << (2*cycle_cnt));
               -3'sd2: accumulator <= accumulator - (multiplicand_x2 << (2*cycle_cnt));
                default: ; // no operation
            endcase

            // Arithmetic right shift multiplier register by 2 bits to process next Booth bits
            // Maintain sign extension on left bits
            multiplier_reg <= multiplier_reg >>> 2;

            // Increment cycle count
            cycle_cnt <= cycle_cnt + 1;

            if (cycle_cnt == 4) begin
                rdy <= 1;
                p <= accumulator[15:0]; // output final product lower 16 bits
            end
        end
    end

endmodule