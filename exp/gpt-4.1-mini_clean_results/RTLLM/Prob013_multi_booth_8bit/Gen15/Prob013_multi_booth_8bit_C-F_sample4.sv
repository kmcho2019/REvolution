module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand (signed)
    input      [7:0]  b,      // multiplier   (signed)
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;

    // Sign-extended multiplicand (9 bits for radix-4 booth multiples)
    reg signed [8:0] multiplicand;

    // Multiplier extended by one bit LSB (for Booth recoding)
    // It is unsigned here since it is shifted arithmetically and sign bit preserved at MSB
    reg signed [8:0] multiplier;

    // Accumulator to hold partial sums: wider than product to avoid overflow
    reg signed [17:0] accumulator;

    // Step counter: counts from 0 to 4 (5 steps for 8-bit Radix-4 Booth)
    reg [2:0] step;

    // Extracted Booth bits window [2:0] for recoding in current step
    reg [2:0] booth_bits;

    // Function to decode Booth bits and generate partial product
    function signed [17:0] booth_op;
        input [2:0] bits;
        input signed [8:0] mpcand;
        reg signed [17:0] val;
        begin
            case (bits)
                3'b000, 3'b111: val = 18'sd0;
                3'b001, 3'b010: val = {{9{mpcand[8]}}, mpcand};               // +1 * multiplicand
                3'b011:         val = {{8{mpcand[8]}}, mpcand, 1'b0};         // +2 * multiplicand (shift left 1)
                3'b100:         val = -({{8{mpcand[8]}}, mpcand, 1'b0});      // -2 * multiplicand
                3'b101, 3'b110: val = -({{9{mpcand[8]}}, mpcand});            // -1 * multiplicand
                default:        val = 18'sd0;
            endcase
            booth_op = val;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Initialization
            state       <= IDLE;
            multiplicand <= {a[7], a};              // sign-extend to 9 bits
            multiplier   <= {b, 1'b0};              // append zero as b[-1] bit
            accumulator  <= 18'sd0;
            step        <= 3'd0;
            p           <= 16'd0;
            rdy         <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    // When reset released, start multiplication immediately
                    rdy <= 1'b0;
                    step <= 3'd0;
                    accumulator <= 18'sd0;
                    multiplicand <= {a[7], a};
                    multiplier <= {b, 1'b0};
                    p <= 16'd0;
                    state <= BUSY;
                end
                BUSY: begin
                    if (step < 3'd5) begin
                        // Extract 3 bits: multiplier[2:0]
                        booth_bits = multiplier[2:0];

                        // Accumulate partial product shifted by 2*step
                        // Use fixed shift left by (2*step) bits
                        accumulator <= accumulator + (booth_op(booth_bits, multiplicand) <<< (2*step));

                        // Arithmetic shift multiplier right by 2 bits
                        // Preserve sign bit (multiplier[8])
                        multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };

                        step <= step + 1;
                    end else begin
                        // Multiplication complete
                        p <= accumulator[15:0];
                        rdy <= 1'b1;
                        // Hold state and outputs until next reset
                        // Optionally, could go back to IDLE on a start signal if implemented
                    end
                end
                default: begin
                    // Safety fallback to IDLE
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule