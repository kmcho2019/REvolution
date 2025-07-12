module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output wire        rdy    // ready signal
);

    // Sign-extended multiplicand and multiplier registers
    reg signed [15:0] multiplicand;         // 16-bit sign-extended multiplicand
    reg signed [16:0] multiplier_reg;       // 17-bit multiplier + appended zero bit for Booth encoding

    // Accumulator: 32 bits for partial sums
    reg signed [31:0] accumulator;

    // Counter for number of iterations (0 to 4)
    reg [2:0] ctr;

    // Extract Booth bits (lowest 3 bits of multiplier_reg)
    wire [2:0] booth_bits = multiplier_reg[2:0];

    // Booth factor decoded combinationally
    reg signed [2:0] booth_factor;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_factor = 3'sd0;
            3'b001, 3'b010: booth_factor = 3'sd1;
            3'b011:         booth_factor = 3'sd2;
            3'b100:         booth_factor = -3'sd2;
            3'b101, 3'b110: booth_factor = -3'sd1;
            default:        booth_factor = 3'sd0;
        endcase
    end

    // Ready when 4 cycles completed (each cycle processes 2 multiplier bits)
    assign rdy = (ctr == 3'd4);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand   <= {{8{a[7]}}, a};           // sign-extend multiplicand
            multiplier_reg <= {{8{b[7]}}, b, 1'b0};     // sign-extend multiplier and append zero bit
            accumulator    <= 32'sd0;
            ctr            <= 3'd0;
            p              <= 16'd0;
        end else if (!rdy) begin
            // Accumulate partial sum according to booth_factor
            case (booth_factor)
                3'sd0: ; // no op
                3'sd1: accumulator <= accumulator + {{16{multiplicand[15]}}, multiplicand};
                3'sd2: accumulator <= accumulator + ({{16{multiplicand[15]}}, multiplicand} <<< 1);
                -3'sd1: accumulator <= accumulator - {{16{multiplicand[15]}}, multiplicand};
                -3'sd2: accumulator <= accumulator - ({{16{multiplicand[15]}}, multiplicand} <<< 1);
                default: ; // no op
            endcase
            // Arithmetic right shift multiplier_reg by 2 bits
            multiplier_reg <= {multiplier_reg[16], multiplier_reg[16:2]};

            ctr <= ctr + 3'd1;
        end else if (rdy) begin
            // On completion output product low 16 bits
            p <= accumulator[15:0];
        end
    end

endmodule