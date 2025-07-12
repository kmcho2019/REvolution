module multi_booth_8bit (
    input           clk,
    input           reset,
    input   [7:0]   a,      // multiplicand (signed)
    input   [7:0]   b,      // multiplier (signed)
    output reg [15:0] p,    // product output
    output reg       rdy     // ready signal
);

    // FSM states
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;

    // Sign-extended inputs
    reg signed [8:0] multiplicand;   // 9-bit signed multiplicand
    reg signed [8:0] multiplier;     // 9-bit signed multiplier with appended zero LSB (for Booth recoding)

    reg signed [17:0] accumulator;   // 18-bit signed accumulator
    reg [2:0] step;                  // step counter: 0..4 (5 steps for radix-4 on 8 bits)

    wire [2:0] booth_bits;           // current Booth recode bits (3 bits from multiplier LSB)

    // Extract 3 bits from multiplier for Booth recoding (bits [2:0])
    assign booth_bits = multiplier[2:0];

    // Combinational Booth partial product generation according to Booth encoding
    reg signed [17:0] partial_product;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 18'sd0;  // 0
            3'b001, 3'b010: partial_product = {{9{multiplicand[8]}}, multiplicand};               // +1 * multiplicand
            3'b011:         partial_product = {{8{multiplicand[8]}}, multiplicand, 1'b0};        // +2 * multiplicand (shift left 1)
            3'b100:         partial_product = -({{8{multiplicand[8]}}, multiplicand, 1'b0});      // -2 * multiplicand
            3'b101, 3'b110: partial_product = -({{9{multiplicand[8]}}, multiplicand});           // -1 * multiplicand
            default:        partial_product = 18'sd0;                                           // Should not happen
        endcase
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = reset ? RUN : IDLE;
            RUN:  next_state = (step == 3'd4) ? DONE : RUN;
            DONE: next_state = reset ? RUN : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: FSM, registers, outputs
    always @(posedge clk) begin
        if (reset) begin
            // Load inputs and initialize on reset
            multiplicand <= {a[7], a};            // sign-extend multiplicand to 9 bits
            multiplier <= {b, 1'b0};              // multiplier extended with zero LSB for Booth recoding
            accumulator <= 18'sd0;
            step <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
            state <= RUN;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
                RUN: begin
                    // Accumulate the partial product shifted by 2*step (radix-4)
                    accumulator <= accumulator + (partial_product <<< (2*step));
                    // Arithmetic right shift multiplier by 2 bits, sign-extended
                    multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };
                    // Increment step counter
                    step <= step + 1'b1;
                    rdy <= 1'b0;
                end
                DONE: begin
                    // Output result and assert ready
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                    // Hold values stable until next reset
                end
                default: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
            endcase
        end
    end

endmodule