module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // States for FSM
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        CALC = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    // Sign-extended multiplicand (17 bits)
    reg signed [16:0] multiplicand;

    // Multiplier register with appended 1 bit LSB zero for Booth encoding (17 bits)
    reg signed [16:0] multiplier_reg;

    // Accumulator for partial sums (signed 34 bits to avoid overflow)
    reg signed [33:0] accumulator;

    // Cycle counter: 0 to 3 (4 cycles for 8 bits with radix-4)
    reg [2:0] cycle_cnt;

    // Booth code decoder: from 3 bits returns multiply factor (-2..2)
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_decode = 0;
                3'b001, 3'b010: booth_decode = 1;
                3'b011:         booth_decode = 2;
                3'b100:         booth_decode = -2;
                3'b101, 3'b110: booth_decode = -1;
                default:        booth_decode = 0;
            endcase
        end
    endfunction

    // Partial product for current booth code
    reg signed [33:0] partial_product;

    wire [2:0] current_booth_bits;
    wire signed [2:0] booth_mul;

    // Extract bits [1:0] plus previous bit LSB of multiplier_reg for current booth code
    assign current_booth_bits = {multiplier_reg[1:0], multiplier_reg[0]};

    // Booth multiplier factor for partial product
    assign booth_mul = booth_decode(current_booth_bits);

    // Compute partial product combinationally
    always @(*) begin
        case (booth_mul)
            3'd0: partial_product = 34'd0;
            3'd1: partial_product = {{17{multiplicand[16]}}, multiplicand};
            3'd2: partial_product = {{17{multiplicand[16]}}, multiplicand} <<< 1; // times 2
            -3'd1: partial_product = -({{17{multiplicand[16]}}, multiplicand});
            -3'd2: partial_product = -({{17{multiplicand[16]}}, multiplicand} <<< 1);
            default: partial_product = 34'd0;
        endcase
    end

    // FSM state register and counter update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state        <= IDLE;
            rdy          <= 1'b0;
            p            <= 16'd0;
            cycle_cnt    <= 3'd0;
            accumulator  <= 34'd0;
            multiplicand <= {{9{a[7]}}, a};       // sign-extend 8->17 bits
            multiplier_reg <= {{8{b[7]}}, b, 1'b0}; // sign-extend 8->16 plus 1 LSB zero bit, total 17 bits
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    cycle_cnt <= 3'd0;
                    accumulator <= 34'd0;
                    multiplicand <= {{9{a[7]}}, a};
                    multiplier_reg <= {{8{b[7]}}, b, 1'b0};
                end

                CALC: begin
                    // Add partial product aligned at current LSB position (accumulator lower bits)
                    accumulator <= accumulator + (partial_product);
                    // Arithmetic right shift multiplier_reg by 2 bits (to get next booth bits)
                    // Shift in sign bit for sign extension
                    multiplier_reg <= $signed(multiplier_reg) >>> 2;
                    cycle_cnt <= cycle_cnt + 1;
                end

                DONE: begin
                    // Output lower 16 bits of accumulator as product
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = CALC;
            CALC:  next_state = (cycle_cnt == 3'd3) ? DONE : CALC;
            DONE:  next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule