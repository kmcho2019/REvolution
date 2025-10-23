module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,      // multiplicand
    input  wire [7:0]  b,      // multiplier
    output reg  [15:0] p,      // product output
    output reg         rdy      // ready signal
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01
    } state_t;

    state_t state, next_state;

    reg signed [15:0] multiplicand;          // sign-extended multiplicand
    reg signed [16:0] multiplier_reg;        // multiplier with appended zero bit (17 bits)
    reg signed [31:0] accumulator;           // accumulator for partial sums
    reg [2:0]         cycle_cnt;              // up to 4 cycles needed for 8-bit Radix-4

    // Extract Booth bits from multiplier_reg[1:0] + appended zero bit (bit -1)
    wire [2:0] booth_bits = {multiplier_reg[1], multiplier_reg[0], 1'b0};

    // Booth decode function: maps 3 bits to signed factor (-2..2)
    function signed [2:0] booth_decode(input [2:0] bits);
        case (bits)
            3'b000, 3'b111: booth_decode = 3'sd0;
            3'b001, 3'b010: booth_decode = 3'sd1;
            3'b011:         booth_decode = 3'sd2;
            3'b100:         booth_decode = -3'sd2;
            3'b101, 3'b110: booth_decode = -3'sd1;
            default:        booth_decode = 3'sd0;
        endcase
    endfunction

    wire signed [2:0] booth_factor = booth_decode(booth_bits);

    // Partial product computation based on booth_factor
    // Shifts multiplicand by 2*cycle_cnt for alignment in accumulator
    wire signed [31:0] partial_product;
    assign partial_product =
        (booth_factor == 3'sd0) ? 32'sd0 :
        (booth_factor == 3'sd1) ? ({{16{multiplicand[15]}}, multiplicand} <<< (cycle_cnt*2)) :
        (booth_factor == 3'sd2) ? ({{16{multiplicand[15]}}, multiplicand} <<< (cycle_cnt*2 + 1)) :  // multiply by 2 = shift 1 more
        (booth_factor == -3'sd1) ? -({{16{multiplicand[15]}}, multiplicand} <<< (cycle_cnt*2)) :
        (booth_factor == -3'sd2) ? -({{16{multiplicand[15]}}, multiplicand} <<< (cycle_cnt*2 + 1)) :
        32'sd0;

    // FSM sequential block
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= {{8{a[7]}}, a};
            multiplier_reg <= {{8{b[7]}}, b, 1'b0};
            accumulator <= 32'sd0;
            cycle_cnt <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    if (1) begin // In this simplified design, start immediately at CALC after reset
                        multiplicand <= {{8{a[7]}}, a};
                        multiplier_reg <= {{8{b[7]}}, b, 1'b0};
                        accumulator <= 32'sd0;
                        cycle_cnt <= 3'd0;
                    end
                end
                CALC: begin
                    // Accumulate partial product
                    accumulator <= accumulator + partial_product;
                    // Arithmetic right shift multiplier_reg by 2
                    multiplier_reg <= multiplier_reg >>> 2;
                    // Increment cycle counter
                    cycle_cnt <= cycle_cnt + 1;
                    // At last cycle output result and set ready
                    if (cycle_cnt == 3'd3) begin
                        p <= accumulator[15:0];
                        rdy <= 1'b1;
                    end
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = CALC;
            CALC:    next_state = (cycle_cnt == 3'd3) ? IDLE : CALC;
            default: next_state = IDLE;
        endcase
    end

endmodule