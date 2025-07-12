module multi_booth_8bit (
    input          clk,
    input          reset,
    input  [7:0]   a,         // multiplicand (signed)
    input  [7:0]   b,         // multiplier   (signed)
    output reg [15:0] p,      // product output
    output reg      rdy        // ready signal
);

    // FSM states
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] step, next_step; // up to 5 steps for radix-4 (8 bits / 2 bits per step + extra)

    // Internal registers
    // multiplicand sign-extended to 9 bits for Booth partial products
    reg signed [8:0] multiplicand;
    // multiplier extended to 10 bits: 8 bits + 1 extra bit (b[-1]) + 1 MSB padding to keep sign on shift
    reg signed [9:0] multiplier;

    // Accumulator for partial sum (18 bits to hold max width)
    reg signed [17:0] accumulator, next_accumulator;

    // Extract 3 bits for Booth recoding: multiplier bits [2:0]
    wire [2:0] booth_bits = multiplier[2:0];

    // Booth operation function
    // Returns partial product signed 18-bit value according to radix-4 Booth code
    function signed [17:0] booth_op;
        input [2:0] code;
        input signed [8:0] mpcand;
        reg signed [17:0] val;
        begin
            case(code)
                3'b000,
                3'b111: val = 18'sd0;
                3'b001,
                3'b010: val = {{9{mpcand[8]}}, mpcand};            // +1 * multiplicand
                3'b011: val = {{8{mpcand[8]}}, mpcand, 1'b0};     // +2 * multiplicand (shift left 1)
                3'b100: val = -({{8{mpcand[8]}}, mpcand, 1'b0});  // -2 * multiplicand
                3'b101,
                3'b110: val = -({{9{mpcand[8]}}, mpcand});         // -1 * multiplicand
                default: val = 18'sd0;
            endcase
            booth_op = val;
        end
    endfunction

    // Control logic combinational block
    always @(*) begin
        // Defaults
        next_state = state;
        next_step = step;
        next_accumulator = accumulator;
        rdy = 1'b0;
        p = p; // hold default output value

        case(state)
            IDLE: begin
                if (!reset) begin
                    // Start multiplication after reset is released
                    next_state = RUN;
                    next_step = 3'd0;
                    next_accumulator = 18'sd0;
                    // p and rdy remain unchanged here
                end else begin
                    // Hold in IDLE while reset asserted
                    next_state = IDLE;
                end
            end

            RUN: begin
                // Add partial product accumulated shifted by 2*step
                // Partial product = booth_op(...) << (2*step)
                next_accumulator = accumulator + (booth_op(booth_bits, multiplicand) <<< (2*step));
                next_step = step + 1;

                // Shift multiplier arithmetically right by 2 bits to prepare next booth_bits
                // multiplier signed 10-bit arithmetic right shift by 2
                // Implemented with concatenation to avoid timing issues
                // The next multiplier will be assigned in sequential block

                if (next_step == 3'd5) begin
                    // Completed all steps
                    next_state = DONE;
                end else begin
                    next_state = RUN;
                end
            end

            DONE: begin
                // Multiplication complete, output ready and product stable
                rdy = 1'b1;
                p = accumulator[15:0];  // lower 16 bits of accumulator

                // Hold state and values until reset
                next_state = DONE;
                next_step = step;
                next_accumulator = accumulator;
            end

            default: begin
                // Safety fallback to IDLE
                next_state = IDLE;
            end
        endcase
    end

    // Sequential block updates state and registers synchronously
    always @(posedge clk) begin
        if (reset) begin
            // On reset, initialize registers
            state <= IDLE;
            step <= 3'd0;
            accumulator <= 18'sd0;
            p <= 16'd0;
            rdy <= 1'b0;

            // Sign-extend multiplicand and multiplier on reset assertion
            // Note: per specification, multiplicand <= {{8{a[7]}}, a}
            // but in example 1 multiplicand is a, multiplier is b, so careful:
            multiplicand <= {a[7], a};
            multiplier <= {b, 2'b00}; // Initialize multiplier with two 0 bits appended for Booth recoding (including b[-1])

        end else begin
            state <= next_state;
            step <= next_step;
            accumulator <= next_accumulator;

            // Shift multiplier arithmetically right by 2 bits during RUN
            if (state == RUN) begin
                // Arithmetic right shift by 2 bits:
                // MSB replicated twice, bits [9:2] shifted down
                multiplier <= { {2{multiplier[9]}}, multiplier[9:2] };
            end else if (state == IDLE) begin
                // Reload inputs when reset deasserts (if desired)
                // This is handled on reset assertion only, no change here
                multiplier <= multiplier;
            end else begin
                // Hold multiplier stable in DONE and other states
                multiplier <= multiplier;
            end

            // Output registers updated in DONE state
            if (state == DONE) begin
                p <= accumulator[15:0];
                rdy <= 1'b1;
            end else begin
                p <= 16'd0;
                rdy <= 1'b0;
            end

            // Multiplicand remains constant during operation
            // Keep stable except on reset
            if (reset) begin
                multiplicand <= {a[7], a};
            end else begin
                multiplicand <= multiplicand;
            end
        end
    end

endmodule