module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,      // multiplicand (signed)
    input  [7:0]    b,      // multiplier   (signed)
    output reg [15:0] p,    // product output
    output reg       rdy     // ready signal
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Internal registers
    reg signed [8:0] multiplicand;      // 9-bit signed multiplicand
    reg [8:0] multiplier;                // multiplier + 1 zero LSB for Booth recoding (unsigned)
    reg signed [17:0] accumulator;      // 18-bit signed accumulator for partial sums
    reg [2:0] step;                     // step counter: 0 to 4 (5 steps for 8-bit radix-4 Booth)

    wire [2:0] booth_bits;
    assign booth_bits = multiplier[2:0];

    // Booth decoding function: maps 3 bits to partial product * multiplicand
    function signed [17:0] booth_decode;
        input [2:0] bits;
        input signed [8:0] mpcand;
        begin
            case(bits)
                3'b000, 3'b111: booth_decode = 18'sd0;
                3'b001, 3'b010: booth_decode = {{9{mpcand[8]}}, mpcand};         // +1 * multiplicand
                3'b011:         booth_decode = {{8{mpcand[8]}}, mpcand, 1'b0};  // +2 * multiplicand (shift left 1)
                3'b100:         booth_decode = -({{8{mpcand[8]}}, mpcand, 1'b0}); // -2 * multiplicand
                3'b101, 3'b110: booth_decode = -({{9{mpcand[8]}}, mpcand});      // -1 * multiplicand
                default:        booth_decode = 18'sd0;
            endcase
        end
    endfunction

    // FSM next state logic (Moore machine)
    always @(*) begin
        case(state)
            IDLE:  next_state = (reset == 1'b0) ? CALC : IDLE;
            CALC:  next_state = (step == 3'd5) ? DONE : CALC;
            DONE:  next_state = (reset == 1'b1) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: FSM state and datapath update
    always @(posedge clk) begin
        if (reset) begin
            // On reset, initialize everything
            state       <= IDLE;
            multiplicand <= {a[7], a};          // sign-extend multiplicand to 9 bits
            multiplier   <= {b, 1'b0};          // multiplier extended with 1 zero bit LSB for Booth recoding
            accumulator  <= 18'sd0;
            step         <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Prepare registers for multiplication start
                    multiplicand <= multiplicand;   // hold stable
                    multiplier   <= multiplier;     // hold stable
                    accumulator  <= 18'sd0;
                    step         <= 3'd0;
                    p            <= 16'd0;
                    rdy          <= 1'b0;
                end

                CALC: begin
                    // Accumulate partial product shifted by 2*step bits
                    accumulator <= accumulator + (booth_decode(booth_bits, multiplicand) <<< (2*step));

                    // Arithmetic shift right multiplier by 2 bits with sign extension
                    multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };

                    step <= step + 1'b1;

                    // outputs hold previous values during calculation
                    p   <= p;
                    rdy <= 1'b0;
                end

                DONE: begin
                    // Output valid product (lower 16 bits)
                    p   <= accumulator[15:0];
                    rdy <= 1'b1;

                    // hold other registers stable
                    multiplicand <= multiplicand;
                    multiplier   <= multiplier;
                    accumulator  <= accumulator;
                    step         <= step;
                end

                default: begin
                    // Default safe values
                    multiplicand <= {a[7], a};
                    multiplier   <= {b, 1'b0};
                    accumulator  <= 18'sd0;
                    step         <= 3'd0;
                    p            <= 16'd0;
                    rdy          <= 1'b0;
                end
            endcase
        end
    end

endmodule