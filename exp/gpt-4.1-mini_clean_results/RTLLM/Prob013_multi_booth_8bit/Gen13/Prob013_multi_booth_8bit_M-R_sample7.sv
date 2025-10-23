module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,      // multiplicand (signed)
    input  [7:0]    b,      // multiplier   (signed)
    output reg [15:0] p,    // product
    output reg       rdy     // ready signal
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        RUN  = 2'd1,
        DONE = 2'd2
    } state_t;

    reg [1:0] state, next_state;

    // Internal registers
    reg signed [8:0] multiplicand;   // sign-extended multiplicand (9 bits)
    reg signed [8:0] multiplier;     // extended multiplier with extra bit (9 bits) for Booth recoding
    reg signed [17:0] accumulator;   // 18-bit accumulator for partial sums
    reg [2:0] step;                  // counter for up to 5 steps (0 to 4)

    // Combinational wires for Booth recoding and partial product
    wire [2:0] booth_bits;
    reg signed [17:0] partial_product;

    // Extract booth_bits: 3 LSBs of multiplier
    assign booth_bits = multiplier[2:0];

    // Booth operation combinational logic
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 18'sd0;
            3'b001, 3'b010: partial_product = {{9{multiplicand[8]}}, multiplicand};        // +1 * multiplicand
            3'b011:         partial_product = {{8{multiplicand[8]}}, multiplicand, 1'b0};  // +2 * multiplicand (shifted left 1)
            3'b100:         partial_product = -({{8{multiplicand[8]}}, multiplicand, 1'b0}); // -2 * multiplicand
            3'b101, 3'b110: partial_product = -({{9{multiplicand[8]}}, multiplicand});     // -1 * multiplicand
            default:        partial_product = 18'sd0;
        endcase
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = reset ? RUN : IDLE;
            RUN:  next_state = (step == 3'd4) ? DONE : RUN;
            DONE: next_state = reset ? RUN : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: registers update
    always @(posedge clk) begin
        if (reset) begin
            // Load inputs into internal regs with sign extension
            multiplicand <= {a[7], a};
            multiplier   <= {b, 1'b0};  // LSB zero for Booth recoding extra bit
            accumulator  <= 18'sd0;
            step         <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
            state        <= RUN;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
                RUN: begin
                    // Accumulate partial product shifted by 2*step
                    accumulator <= accumulator + (partial_product <<< (2*step));
                    // Arithmetic shift right multiplier by 2 bits (sign extend)
                    multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };
                    step <= step + 1'b1;
                    rdy <= 1'b0;
                end
                DONE: begin
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                    // Hold registers stable, wait for reset to start again
                end
            endcase
        end
    end

endmodule