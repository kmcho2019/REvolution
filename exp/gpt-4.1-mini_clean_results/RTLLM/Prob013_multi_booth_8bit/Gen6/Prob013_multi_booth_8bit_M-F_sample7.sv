module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,   // multiplicand
    input  wire [7:0]  b,   // multiplier
    output reg  [15:0] p,   // product output
    output reg         rdy   // ready signal
);

    // Internal signals
    reg signed [15:0] multiplicand;       // sign-extended multiplicand
    reg signed [15:0] multiplicand_x2;    // 2 * multiplicand

    reg signed [16:0] multiplier_reg;     // multiplier with appended zero LSB (9 bits)
    reg signed [31:0] accumulator;        // 32-bit accumulator to hold partial product

    reg [1:0] cycle_cnt;                   // cycle count: 0 to 3 for 4 radix-4 cycles

    wire [2:0] booth_bits;                 // bits for booth encoding

    reg signed [2:0] booth_factor;

    // Pre-shifted multiplicand values for cycles 0 to 3
    // For multiplicand and multiplicand_x2 shifted by 0,2,4,6 bits (i.e. << (2*cycle))
    reg signed [31:0] mux_multiplicand [0:3];     // multiplicand shifted by 0,2,4,6
    reg signed [31:0] mux_multiplicand_x2 [0:3];  // multiplicand_x2 shifted by 0,2,4,6

    integer i;

    // Extract booth bits: multiplier_reg[1:0] + appended 0 (LSB)
    assign booth_bits = {multiplier_reg[1], multiplier_reg[0], 1'b0};

    // Booth decoding
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_factor =  0;
            3'b001, 3'b010: booth_factor =  1;
            3'b011:         booth_factor =  2;
            3'b100:         booth_factor = -2;
            3'b101, 3'b110: booth_factor = -1;
            default:        booth_factor =  0;
        endcase
    end

    // Precompute shifted multiplicands combinationally each cycle
    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            mux_multiplicand[i]    = multiplicand <<< (2 * i);
            mux_multiplicand_x2[i] = multiplicand_x2 <<< (2 * i);
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend multiplicand and multiplier, reset registers
            multiplicand    <= {{8{a[7]}}, a};
            multiplicand_x2 <= ({{8{a[7]}}, a}) <<< 1;

            multiplier_reg  <= {{8{b[7]}}, b, 1'b0}; // multiplier + appended 0 LSB

            accumulator     <= 0;
            cycle_cnt       <= 0;
            p               <= 0;
            rdy             <= 0;
        end else if (!rdy) begin
            // Apply Booth factor based on current cycle using pre-shifted values
            case (booth_factor)
                3'sd0: ; // no operation
                3'sd1: accumulator <= accumulator + mux_multiplicand[cycle_cnt];
                3'sd2: accumulator <= accumulator + mux_multiplicand_x2[cycle_cnt];
               -3'sd1: accumulator <= accumulator - mux_multiplicand[cycle_cnt];
               -3'sd2: accumulator <= accumulator - mux_multiplicand_x2[cycle_cnt];
                default: ; // no operation
            endcase

            // Arithmetic right shift multiplier register by 2 bits (processing next 2 Booth bits)
            multiplier_reg <= multiplier_reg >>> 2;

            // Increment cycle counter
            cycle_cnt <= cycle_cnt + 1;

            if (cycle_cnt == 2'd3) begin
                // Last cycle done, set ready and output product (lower 16 bits)
                rdy <= 1;
                p <= accumulator[15:0];
            end
        end
    end

endmodule