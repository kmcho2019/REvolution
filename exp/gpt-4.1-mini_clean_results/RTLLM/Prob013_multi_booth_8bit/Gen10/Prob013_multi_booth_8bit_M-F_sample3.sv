module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // State encoding using localparam to ensure synthesis compatibility
    localparam IDLE = 2'd0;
    localparam CALC = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state;

    // Sign-extended multiplicand and multiplier registers
    reg signed [15:0] multiplicand;         // 16-bit sign-extended multiplicand
    reg signed [16:0] multiplier_reg;       // 17-bit multiplier + appended zero bit for Booth encoding

    // Signed 32-bit multiplicand for accumulator operations (sign-extended once)
    reg signed [31:0] multiplicand_32;

    // Accumulator: 32 bits to hold intermediate sums safely
    reg signed [31:0] accumulator;

    // 3-bit counter for four cycles (0 to 3)
    reg [2:0] ctr;

    wire [2:0] booth_bits;
    reg signed [2:0] booth_factor;

    // Extract Booth bits (lowest 3 bits of multiplier_reg)
    assign booth_bits = multiplier_reg[2:0];

    // Booth factor combinational decoding
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

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize multiplicand and multiplier registers with sign extension
            multiplicand   <= {{8{a[7]}}, a};
            multiplicand_32 <= {{16{a[7]}}, a};  // sign-extend once to 32 bits
            multiplier_reg <= {{8{b[7]}}, b, 1'b0};  // 17 bits with appended zero bit
            accumulator    <= 32'sd0;
            ctr            <= 3'd0;
            p              <= 16'd0;
            rdy            <= 1'b0;
            state          <= CALC;   // Start calculation immediately after reset
        end else begin
            case(state)
                IDLE: begin
                    // Wait here if needed; in this design reset triggers start immediately
                    rdy <= 1'b0;
                    p   <= 16'd0;
                end

                CALC: begin
                    // Only update accumulator if booth_factor != 0 to reduce toggling
                    if (booth_factor != 3'sd0) begin
                        case (booth_factor)
                            3'sd1:  accumulator <= accumulator + multiplicand_32;
                            3'sd2:  accumulator <= accumulator + (multiplicand_32 <<< 1);
                            -3'sd1: accumulator <= accumulator - multiplicand_32;
                            -3'sd2: accumulator <= accumulator - (multiplicand_32 <<< 1);
                            default: ; // no change
                        endcase
                    end
                    // Arithmetic right shift multiplier_reg by 2 bits
                    multiplier_reg <= {multiplier_reg[16], multiplier_reg[16:2]};

                    ctr <= ctr + 3'd1;

                    // Transition to DONE after 4 cycles
                    if (ctr == 3'd3) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Output final product and assert ready
                    p   <= accumulator[15:0];
                    rdy <= 1'b1;
                    // Hold state here until next reset
                end

                default: begin
                    // Should never happen, reset state
                    state <= IDLE;
                    rdy   <= 1'b0;
                    p     <= 16'd0;
                end
            endcase
        end
    end

endmodule