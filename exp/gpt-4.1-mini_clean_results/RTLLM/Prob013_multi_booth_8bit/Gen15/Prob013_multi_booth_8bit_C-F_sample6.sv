module multi_booth_8bit (
    input          clk,
    input          reset,
    input  [7:0]   a,    // multiplicand (signed)
    input  [7:0]   b,    // multiplier (signed)
    output reg [15:0] p, // product output
    output reg      rdy   // ready signal
);

    // FSM states
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers
    reg signed [8:0] multiplicand;      // 9-bit sign-extended multiplicand
    reg signed [8:0] multiplier;        // 9-bit multiplier extended by 1 LSB zero bit (for Booth recoding)
    reg signed [17:0] accumulator;      // 18-bit accumulator to store partial sums
    reg [2:0] step;                     // step counter (0 to 4)

    wire [2:0] booth_bits;              // 3 bits for current Booth recode window

    // Extract current 3 bits from multiplier for Booth recoding
    assign booth_bits = multiplier[2:0];

    // Combinational logic for partial product according to Booth recode bits
    reg signed [17:0] partial_product;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 18'sd0;
            3'b001, 3'b010: partial_product = {{9{multiplicand[8]}}, multiplicand};                  // +1 * multiplicand
            3'b011:         partial_product = {{8{multiplicand[8]}}, multiplicand, 1'b0};           // +2 * multiplicand (shift left 1)
            3'b100:         partial_product = -({{8{multiplicand[8]}}, multiplicand, 1'b0});         // -2 * multiplicand
            3'b101, 3'b110: partial_product = -({{9{multiplicand[8]}}, multiplicand});              // -1 * multiplicand
            default:        partial_product = 18'sd0;
        endcase
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = reset ? RUN : IDLE;
            RUN:  next_state = (step == 3'd4) ? DONE : RUN;
            DONE: next_state = reset ? RUN : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state machine, registers, outputs
    always @(posedge clk) begin
        if (reset) begin
            // Load inputs and initialize internal states on reset
            multiplicand <= {a[7], a};         // sign-extend multiplicand to 9 bits
            multiplier <= {b, 1'b0};            // multiplier extended with 0 bit at LSB for Booth recoding
            accumulator <= 18'sd0;
            step <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
            state <= RUN;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end

                RUN: begin
                    // Accumulate shifted partial product
                    accumulator <= accumulator + (partial_product <<< (2 * step));
                    // Arithmetic right shift multiplier by 2 bits (sign-extend)
                    multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };
                    // Increment step
                    step <= step + 1'b1;
                    rdy <= 1'b0;
                end

                DONE: begin
                    // Output result and assert ready
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                    // Hold stable outputs and states until next reset
                end

                default: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
            endcase
        end
    end

endmodule