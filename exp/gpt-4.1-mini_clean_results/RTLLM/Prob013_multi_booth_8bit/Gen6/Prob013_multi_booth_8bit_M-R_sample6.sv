module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        BUSY = 2'b01,
        DONE = 2'b10
    } state_t;

    reg signed [15:0] multiplicand;    // sign-extended multiplicand
    reg signed [15:0] multiplicand_x2; // 2 * multiplicand
    reg signed [16:0] multiplier_reg;  // multiplier with appended zero LSB (9 bits)
    reg signed [31:0] accumulator;     // accumulator for partial sums
    reg [2:0]         cycle_cnt;       // cycle count: 0 to 3 (4 cycles total)
    state_t           state;

    // Extract 3 bits for Booth encoding from multiplier_reg: bits [1:0] and appended 0 as LSB
    wire [2:0] booth_bits = {multiplier_reg[1], multiplier_reg[0], 1'b0};

    // Booth factor decoded combinationally
    reg signed [2:0] booth_factor;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_factor =  3'sd0;
            3'b001, 3'b010: booth_factor =  3'sd1;
            3'b011:         booth_factor =  3'sd2;
            3'b100:         booth_factor = -3'sd2;
            3'b101, 3'b110: booth_factor = -3'sd1;
            default:        booth_factor =  3'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Load inputs, initialize registers and signals
            multiplicand    <= {{8{a[7]}}, a};
            multiplicand_x2 <= ({{8{a[7]}}, a}) <<< 1;
            multiplier_reg  <= {{8{b[7]}}, b, 1'b0}; // Append 0 LSB
            accumulator     <= 32'd0;
            cycle_cnt       <= 3'd0;
            state           <= BUSY;
            p               <= 16'd0;
            rdy             <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Wait here until reset triggers BUSY state
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
                BUSY: begin
                    // Perform partial product accumulation per Booth factor
                    case (booth_factor)
                        3'sd0: accumulator <= accumulator; // no change
                        3'sd1: accumulator <= accumulator + (multiplicand <<< (2*cycle_cnt));
                        3'sd2: accumulator <= accumulator + (multiplicand_x2 <<< (2*cycle_cnt));
                       -3'sd1: accumulator <= accumulator - (multiplicand <<< (2*cycle_cnt));
                       -3'sd2: accumulator <= accumulator - (multiplicand_x2 <<< (2*cycle_cnt));
                        default: accumulator <= accumulator;
                    endcase

                    // Arithmetic right shift multiplier_reg by 2 bits (sign-extended)
                    multiplier_reg <= multiplier_reg >>> 2;

                    // Increment cycle count
                    cycle_cnt <= cycle_cnt + 3'd1;

                    // When 4 cycles done, transition to DONE state
                    if (cycle_cnt == 3'd3) begin
                        state <= DONE;
                        p <= accumulator[15:0];
                        rdy <= 1'b1;
                    end
                end
                DONE: begin
                    // Hold results and ready signal until next reset
                    rdy <= 1'b1;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule