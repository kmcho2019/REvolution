module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,      // multiplicand (signed)
    input  [7:0]    b,      // multiplier   (signed)
    output reg [15:0] p,    // product
    output reg       rdy     // ready signal
);

    // FSM states definition
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        RUN  = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    // Internal registers
    // Sign-extend multiplicand (a) to 9 bits
    reg signed [8:0] multiplicand;
    // Multiplier extended by 1 bit (9 bits) for radix-4 Booth encoding
    reg signed [8:0] multiplier;
    // Accumulator to hold intermediate sums, 18 bits to avoid overflow
    reg signed [17:0] accumulator;
    // Step counter: up to 5 cycles (0..4)
    reg [2:0] step;

    // Combinational wires for Booth recoding and partial product generation
    wire [2:0] booth_bits;        // Current 3 bits from multiplier for Booth recoding
    reg signed [17:0] partial_product; // Partial product from Booth recoding

    // Assign booth_bits to 3 LSBs of multiplier
    assign booth_bits = multiplier[2:0];

    // Combinational Booth recoding logic to generate partial product
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 18'sd0;
            3'b001, 3'b010: partial_product = {{9{multiplicand[8]}}, multiplicand};           // +1 * multiplicand
            3'b011:         partial_product = {{8{multiplicand[8]}}, multiplicand, 1'b0};     // +2 * multiplicand (shift left 1)
            3'b100:         partial_product = -({{8{multiplicand[8]}}, multiplicand, 1'b0});  // -2 * multiplicand
            3'b101, 3'b110: partial_product = -({{9{multiplicand[8]}}, multiplicand});        // -1 * multiplicand
            default:        partial_product = 18'sd0;
        endcase
    end

    // FSM next state logic combinational
    always @(*) begin
        case (state)
            IDLE: next_state = reset ? RUN : IDLE;
            RUN:  next_state = (step == 3'd4) ? DONE : RUN;
            DONE: next_state = reset ? RUN : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential block for FSM and datapath registers update
    always @(posedge clk) begin
        if (reset) begin
            // On reset, load inputs (multiplicand and multiplier) and initialize
            multiplicand <= {a[7], a};      // sign-extend multiplicand (a)
            multiplier   <= {b, 1'b0};      // multiplier with appended zero LSB for Booth recode
            accumulator  <= 18'sd0;         // clear accumulator
            step         <= 3'd0;           // reset step counter
            p            <= 16'd0;          // clear output product
            rdy          <= 1'b0;           // clear ready
            state        <= RUN;            // move to RUN state on reset
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end

                RUN: begin
                    // Accumulate the partial product shifted left by 2*step (radix-4)
                    accumulator <= accumulator + (partial_product <<< (2 * step));
                    // Arithmetic shift right the multiplier by 2 bits to get next 3 bits for Booth recode
                    multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };
                    // Increment step counter
                    step <= step + 1'b1;
                    rdy <= 1'b0;
                end

                DONE: begin
                    // On done, output lower 16 bits of accumulator as product and assert ready
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                    // Hold registers stable until next reset
                end
            endcase
        end
    end

endmodule