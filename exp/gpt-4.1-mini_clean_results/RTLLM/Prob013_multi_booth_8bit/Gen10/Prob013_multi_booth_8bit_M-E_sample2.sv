module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // FSM states
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state;

    // Sign-extend multiplicand to 16 bits
    reg signed [15:0] multiplicand;

    // Multiplier register: 17 bits (8 bits multiplier + extra zero LSB)
    reg signed [16:0] multiplier_reg;

    // Accumulator: 34 bits to safely hold intermediate sums (+/-)
    reg signed [33:0] accumulator;

    // 2-bit counter for 4 cycles (Radix-4: process 2 bits per cycle)
    reg [1:0] ctr;

    // Extract booth bits (lowest 3 bits of multiplier_reg)
    wire [2:0] booth_bits = multiplier_reg[2:0];

    // Booth factor decoding (combinational)
    // Mapping 3 bits to multiplier factor: -2, -1, 0, 1, 2
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

    // State machine and main process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            state        <= IDLE;
            multiplicand <= {{8{a[7]}}, a};          // sign-extend a
            multiplier_reg <= {{8{b[7]}}, b, 1'b0};  // sign-extend b plus appended zero LSB
            accumulator  <= 34'sd0;
            ctr          <= 2'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Wait one cycle then start
                    rdy <= 1'b0;
                    accumulator <= 34'sd0;
                    ctr <= 2'd0;
                    state <= RUN;
                end
                RUN: begin
                    // Compute partial product per booth_factor
                    // multiplicand_ext is multiplicand sign-extended to 34 bits
                    // multiplicand shifted by 1 bit (×2) for factor ±2
                    // Use fixed shift only (no variable shifts)
                    // Prepare multiplicand extended once
                    // Add/subtract partial product
                    case (booth_factor)
                        3'sd0: ; // no operation
                        3'sd1: accumulator <= accumulator + {{18{multiplicand[15]}}, multiplicand};
                        3'sd2: accumulator <= accumulator + ({{18{multiplicand[15]}}, multiplicand} << 1);
                        -3'sd1: accumulator <= accumulator - {{18{multiplicand[15]}}, multiplicand};
                        -3'sd2: accumulator <= accumulator - ({{18{multiplicand[15]}}, multiplicand} << 1);
                        default: ; // should not happen
                    endcase

                    // Arithmetic right shift multiplier_reg by 2 bits
                    // sign-extend the two top bits
                    multiplier_reg <= {multiplier_reg[16], multiplier_reg[16], multiplier_reg[16:2]};

                    // Increment cycle count
                    ctr <= ctr + 1'b1;

                    // Check if done
                    if (ctr == 2'd3) begin
                        // Done after 4 cycles total
                        p <= accumulator[15:0];
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    // Remain in DONE state, ready asserted
                    // Latch product and ready
                    rdy <= 1'b1;
                    p <= accumulator[15:0];
                end
            endcase
        end
    end

endmodule