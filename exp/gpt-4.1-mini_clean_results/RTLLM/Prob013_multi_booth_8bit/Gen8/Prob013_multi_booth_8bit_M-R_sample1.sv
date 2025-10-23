module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Internal registers
    reg signed [15:0] multiplicand;          // sign-extended multiplicand
    reg signed [16:0] multiplier_reg;        // multiplier extended with appended zero bit for Booth (17 bits)
    reg signed [31:0] accumulator;           // accumulator wider to avoid overflow
    reg [2:0]         ctr;                    // 3-bit counter (0 to 4 for 4 cycles)

    wire [2:0] booth_bits;                    // 3 bits for Booth encoding
    reg signed [2:0] booth_factor;            // Booth factor (-2 to 2)

    // Booth bits extraction: always the lowest 3 bits of multiplier_reg
    assign booth_bits = multiplier_reg[2:0];

    // Booth decoding combinational logic
    always @(*) begin
        // Decode the 3-bit booth_bits to booth_factor
        // 000 or 111 => 0
        // 001 or 010 => +1
        // 011        => +2
        // 100        => -2
        // 101 or 110 => -1
        case (booth_bits)
            3'b000, 3'b111: booth_factor = 3'sd0;
            3'b001, 3'b010: booth_factor = 3'sd1;
            3'b011:         booth_factor = 3'sd2;
            3'b100:         booth_factor = -3'sd2;
            3'b101, 3'b110: booth_factor = -3'sd1;
            default:        booth_factor = 3'sd0;
        endcase
    end

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (!reset)
                    next_state = CALC;
                else
                    next_state = IDLE;
            end
            CALC: begin
                if (ctr == 4)
                    next_state = DONE;
                else
                    next_state = CALC;
            end
            DONE: begin
                // Remain in DONE until reset
                next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Datapath sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize registers
            multiplicand   <= {{8{a[7]}}, a};         // 16-bit sign-extended multiplicand
            multiplier_reg <= {{8{b[7]}}, b, 1'b0};   // 17-bit multiplier + appended zero bit
            accumulator    <= 32'sd0;
            ctr            <= 3'd0;
            p              <= 16'd0;
            rdy            <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Load inputs only on reset, stay idle otherwise
                    p   <= 16'd0;
                    rdy <= 1'b0;
                    // inputs remain stable here (waiting for next reset if needed)
                end

                CALC: begin
                    // Accumulate multiplicand * booth_factor shifted by 2*ctr bits
                    if (booth_factor != 0) begin
                        // Shift multiplicand by 2*ctr bits
                        // multiplicand shifted left
                        // Multiplying multiplicand by booth_factor (-2..2)
                        // accumulator updated accordingly
                        case (booth_factor)
                            3'sd1:  accumulator <= accumulator + (multiplicand <<< (2*ctr));
                            3'sd2:  accumulator <= accumulator + ((multiplicand <<< 1) <<< (2*ctr)); // 2 * multiplicand
                            -3'sd1: accumulator <= accumulator - (multiplicand <<< (2*ctr));
                            -3'sd2: accumulator <= accumulator - ((multiplicand <<< 1) <<< (2*ctr));
                            default: accumulator <= accumulator; // no change for 0
                        endcase
                    end else begin
                        accumulator <= accumulator; // no change for 0 factor
                    end

                    // Arithmetic right shift multiplier_reg by 2 bits for next Booth bits
                    multiplier_reg <= $signed(multiplier_reg) >>> 2;

                    // Increment counter
                    ctr <= ctr + 1'b1;
                end

                DONE: begin
                    p   <= accumulator[15:0]; // Output lower 16 bits of the product
                    rdy <= 1'b1;              // Signal completion
                end

                default: ; // no action
            endcase
        end
    end

endmodule