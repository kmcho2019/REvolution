module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,   // multiplicand
    input  wire [7:0]  b,   // multiplier
    output reg  [15:0] p,   // product output
    output reg         rdy   // ready signal
);

    reg signed [15:0] multiplicand;
    reg signed [16:0] multiplier_reg;  // 8 bits + sign extension + appended zero LSB
    reg signed [31:0] accumulator;
    reg [2:0]         cycle_cnt;

    wire [2:0] booth_bits;
    reg signed [2:0] booth_factor;

    // On each cycle extract 3 bits: multiplier_reg[1:0] + multiplier_reg[-1] (appended zero)
    assign booth_bits = {multiplier_reg[1], multiplier_reg[0], 1'b0};

    // Booth decoding: map 3 bits to multiplier factor (-2..2)
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_factor = 0;
            3'b001, 3'b010: booth_factor =  1;
            3'b011:         booth_factor =  2;
            3'b100:         booth_factor = -2;
            3'b101, 3'b110: booth_factor = -1;
            default:        booth_factor = 0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};          // sign-extend 8-bit a to 16 bits
            multiplier_reg <= {{8{b[7]}}, b, 1'b0}; // sign-extend b and append 0 LSB, total 17 bits
            accumulator <= 0;
            cycle_cnt <= 0;
            rdy <= 0;
            p <= 0;
        end else if (!rdy) begin
            // Add partial product = booth_factor * multiplicand shifted by cycle*2 bits
            case (booth_factor)
                3'sd0: ; // no change
                3'sd1: accumulator <= accumulator + (multiplicand <<< (cycle_cnt*2));
                3'sd2: accumulator <= accumulator + ((multiplicand <<< 1) <<< (cycle_cnt*2)); // 2*multiplicand shifted
                -3'sd1: accumulator <= accumulator - (multiplicand <<< (cycle_cnt*2));
                -3'sd2: accumulator <= accumulator - ((multiplicand <<< 1) <<< (cycle_cnt*2));
            endcase

            // Arithmetic right shift multiplier by 2 bits for next iteration
            multiplier_reg <= multiplier_reg >>> 2;

            cycle_cnt <= cycle_cnt + 1;

            if (cycle_cnt == 3) begin
                rdy <= 1;
                p <= accumulator[15:0]; // output lower 16 bits
            end
        end
    end

endmodule