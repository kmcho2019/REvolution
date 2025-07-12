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

    reg [1:0] state, next_state;

    // Sign-extended multiplicand and multiplier registers
    reg signed [15:0] multiplicand;         // 16-bit sign-extended multiplicand
    reg signed [16:0] multiplier_reg;       // 17-bit multiplier + appended zero bit for Booth encoding

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

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (rdy == 1'b0) ? CALC : IDLE;
            CALC: next_state = (ctr == 3'd4) ? DONE : CALC;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand   <= {{8{a[7]}}, a};        // sign-extend multiplicand to 16 bits
            multiplier_reg <= {{8{b[7]}}, b, 1'b0};  // extend multiplier by one appended zero bit (17 bits)
            accumulator    <= 32'sd0;
            ctr            <= 3'd0;
            p              <= 16'd0;
            rdy            <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    // Reset outputs and counters on idle
                    accumulator <= 32'sd0;
                    ctr <= 3'd0;
                    p <= 16'd0;
                    rdy <= 1'b0;
                    // Inputs are latched only on reset
                end

                CALC: begin
                    // Accumulate partial product based on booth_factor
                    // Avoid variable shifts by shifting multiplicand only by 1 bit for factor ±2, else no shift
                    case (booth_factor)
                        3'sd0: ; // no change
                        3'sd1: accumulator <= accumulator + {{16{multiplicand[15]}}, multiplicand}; // multiplicand sign-extended to 32 bits
                        3'sd2: accumulator <= accumulator + ({{16{multiplicand[15]}}, multiplicand} <<< 1); // multiplicand * 2
                        -3'sd1: accumulator <= accumulator - {{16{multiplicand[15]}}, multiplicand};
                        -3'sd2: accumulator <= accumulator - ({{16{multiplicand[15]}}, multiplicand} <<< 1);
                        default: ; // no change
                    endcase

                    // Arithmetic right shift multiplier_reg by 2 bits (Radix-4 processes 2 bits per cycle)
                    // Use fixed shift right by 2 bits, sign-extended
                    multiplier_reg <= {multiplier_reg[16], multiplier_reg[16:2]};

                    ctr <= ctr + 3'd1;
                end

                DONE: begin
                    p <= accumulator[15:0];  // lower 16 bits output as final product
                    rdy <= 1'b1;
                end
            endcase
        end
    end

endmodule