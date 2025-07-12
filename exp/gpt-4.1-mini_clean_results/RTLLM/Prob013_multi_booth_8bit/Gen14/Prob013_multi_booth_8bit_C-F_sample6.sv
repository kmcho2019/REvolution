module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplicand input (signed)
    input      [7:0]  b,        // multiplier input (signed)
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // State encoding (using localparam for synthesis compatibility)
    localparam IDLE = 2'd0,
               RUN  = 2'd1,
               DONE = 2'd2;

    reg [1:0] state, next_state;

    // Signed registers and signals
    reg signed [8:0] multiplicand;      // sign-extended 9 bits (for Booth multiples)
    reg [8:0] multiplier;                // multiplier extended by 1 bit at LSB for Booth recoding (b[-1])
    reg signed [17:0] accumulator;      // accumulator wide enough for partial sums and shifts (18 bits)
    reg [2:0] step;                     // step count: 0 to 4 (5 steps total)

    reg [2:0] booth_bits;               // 3-bit booth encoding bits for current step

    // Booth operation function: generate partial product based on 3 bits and multiplicand
    function signed [17:0] booth_op;
        input [2:0] bits;
        input signed [8:0] mpcand;
        reg signed [17:0] val;
        begin
            case(bits)
                3'b000,
                3'b111: val = 18'sd0;
                3'b001,
                3'b010: val = {{9{mpcand[8]}}, mpcand};          // +1 * multiplicand
                3'b011: val = {{8{mpcand[8]}}, mpcand, 1'b0};    // +2 * multiplicand (shift left by 1)
                3'b100: val = -({{8{mpcand[8]}}, mpcand, 1'b0}); // -2 * multiplicand
                3'b101,
                3'b110: val = -({{9{mpcand[8]}}, mpcand});       // -1 * multiplicand
                default: val = 18'sd0;
            endcase
            booth_op = val;
        end
    endfunction

    // Combinational FSM next state and control signals
    always @(*) begin
        // Default assignments
        next_state = state;
        booth_bits = 3'b000;

        case(state)
            IDLE: begin
                if (!reset)
                    next_state = RUN;
            end

            RUN: begin
                if (step == 3'd5)
                    next_state = DONE;
            end

            DONE: begin
                if (reset)
                    next_state = IDLE;
            end
        endcase
    end

    // Datapath sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            // Sign extend multiplicand and multiplier and initialize multiplier extra bit to 0
            multiplicand <= {a[7], a};       // 9 bits sign-extended multiplicand from 'a'
            multiplier   <= {b, 1'b0};       // 9 bits: b plus 0 LSB for Booth recoding (b[-1])
            accumulator  <= 18'sd0;
            step        <= 3'd0;
            p           <= 16'd0;
            rdy         <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    // Idle state holds outputs and registers stable,
                    // update multiplicand and multiplier only on reset (already done above).
                    rdy <= 1'b0;
                    p   <= 16'd0;
                    accumulator <= 18'sd0;
                    step <= 3'd0;
                end

                RUN: begin
                    if (step < 3'd5) begin
                        // Extract 3 bits for Booth recoding from multiplier bits [2:0]
                        // multiplier bits indexed: LSB = bit0
                        booth_bits = multiplier[2:0];

                        // Add partial product shifted by 2*step bits into accumulator
                        accumulator <= accumulator + (booth_op(booth_bits, multiplicand) <<< (2*step));

                        // Arithmetic shift multiplier right by 2 bits for next step
                        // Preserve sign bit for arithmetic shift right:
                        multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };

                        // Increment step counter
                        step <= step + 1'b1;
                    end
                end

                DONE: begin
                    // Output final product lower 16 bits
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                    // Hold registers stable until reset
                end
            endcase
        end
    end

endmodule