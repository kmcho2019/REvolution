module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplier input
    input      [7:0]  b,        // multiplicand input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        RUN  = 2'b10,
        DONE = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // Extended registers:
    // multiplicand fixed (16-bit signed)
    reg signed [15:0] multiplicand_reg;

    // multiplier extended by 1 bit (17 bits: [15:0] + appended 0 bit LSB)
    reg [16:0] multiplier_ext; // unsigned, but logical bits

    // partial product accumulator (signed 16-bit)
    reg signed [15:0] product_reg;

    // iteration counter (0 to 7)
    reg [3:0] ctr_reg, ctr_next;

    // Booth decoder output: multiply factor for multiplicand:
    // -2, -1, 0, +1, +2
    reg signed [2:0] booth_mult; // 3 bits sufficient: -2..+2

    // partial product for this cycle before addition
    reg signed [15:0] pp_cycle;

    // Temporary 3-bit booth code
    reg [2:0] booth_bits;

    // FSM next state logic and control signals
    always @(*) begin
        next_state = state;
        ctr_next = ctr_reg;
        booth_mult = 3'sd0;

        case (state)
            IDLE: begin
                if (!reset)
                    next_state = LOAD;
            end
            LOAD: begin
                // Initialize counter for 8 cycles
                ctr_next = 4'd0;
                next_state = RUN;
            end
            RUN: begin
                if (ctr_reg < 4'd8) begin
                    // stay in RUN for 8 cycles
                    ctr_next = ctr_reg + 1'b1;
                end else begin
                    next_state = DONE;
                end
            end
            DONE: begin
                // remain DONE until reset
                next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Booth recoding combinational logic based on current 3 bits
    // Booth encoding table (for 3 bits):
    // bits    multiply factor
    // 000,111 =>  0
    // 001,010 => +1
    // 011     => +2
    // 100     => -2
    // 101,110 => -1

    always @(*) begin
        if (state == RUN && ctr_reg < 4'd8) begin
            // Extract 3 bits for current booth group
            // bits: multiplier_ext[2*ctr+1 : 2*ctr-1]
            // For ctr=0, bits [1: -1], since bit -1 = 0 by definition
            // We take care by extending multiplier_ext with one zero bit at LSB
            // So multiplier_ext[16:0] = {multiplier[15:0], 1'b0}
            // booth_bits = bits[2*ctr+1 : 2*ctr-1]

            // For lower bit < 0, safe due to extra appended 0 at LSB

            booth_bits = multiplier_ext[2*ctr_reg + 1 -: 3];
            case (booth_bits)
                3'b000,
                3'b111: booth_mult = 3'sd0;
                3'b001,
                3'b010: booth_mult = 3'sd1;
                3'b011: booth_mult = 3'sd2;
                3'b100: booth_mult = -3'sd2; // -2
                3'b101,
                3'b110: booth_mult = -3'sd1; // -1
                default: booth_mult = 3'sd0;
            endcase
        end else begin
            booth_mult = 3'sd0;
            booth_bits = 3'b000;
        end
    end

    // Calculate partial product for current cycle (booth_mult * multiplicand)
    // Since booth_mult is small (-2..2), multiplication is simple shift and negation

    always @(*) begin
        case (booth_mult)
            3'sd0: pp_cycle = 16'sd0;
            3'sd1: pp_cycle = multiplicand_reg;
            3'sd2: pp_cycle = multiplicand_reg <<< 1;
            -3'sd1: pp_cycle = -multiplicand_reg;
            -3'sd2: pp_cycle = -(multiplicand_reg <<< 1);
            default: pp_cycle = 16'sd0;
        endcase
    end

    // Sequential logic: state, counter, registers update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand_reg <= 16'sd0;
            multiplier_ext <= 17'd0;
            product_reg <= 16'sd0;
            ctr_reg <= 4'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;
            ctr_reg <= ctr_next;

            case (next_state)
                IDLE: begin
                    // Nothing to do
                    rdy <= 1'b0;
                    p <= 16'd0;
                    product_reg <= 16'sd0;
                end
                LOAD: begin
                    // Sign extend inputs:
                    // multiplicand_reg = {{8{b[7]}}, b}
                    // multiplier_ext = {a,1'b0} (append zero LSB)
                    multiplicand_reg <= {{8{b[7]}}, b};
                    multiplier_ext <= {a, 1'b0};
                    product_reg <= 16'sd0;
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
                RUN: begin
                    // On each RUN cycle:
                    // product_reg += pp_cycle shifted by 2*ctr (effectively accumulating partial products)
                    // Instead of shifting product_reg, shift pp_cycle and add.

                    // Since product_reg is always accumulating sums of partial products shifted by 2*ctr,
                    // We implement the shift by shifting pp_cycle left by (2*ctr)

                    // We must keep product_reg aligned at 16 bits.
                    // Since max shift is 14 bits (2*7), sum can overflow 16 bits.
                    // We will limit intermediate results to 32 bits internally and assign lower 16 bits to p at DONE.
                    // To keep product_reg 16-bit, accumulate a wider internal register.

                    // To implement this correctly, use a wider internal accumulator.

                    // This requires an internal wider accumulator (e.g., 32-bit signed), let's add it.

                end
                DONE: begin
                    // Latch output product
                    p <= product_reg[15:0];
                    rdy <= 1'b1;
                end
            endcase
        end
    end

    // To implement the shifting of partial product and accumulation over RUN cycles,
    // add a wider internal accumulator:

    reg signed [31:0] acc_reg, acc_next;

    always @(*) begin
        acc_next = acc_reg;
        if (state == LOAD) begin
            acc_next = 32'sd0;
        end else if (state == RUN && ctr_reg < 4'd8) begin
            // Shift pp_cycle by 2*ctr bits to the left
            acc_next = acc_reg + ( {{16{pp_cycle[15]}}, pp_cycle} <<< (2*ctr_reg) );
        end
        // Else hold value
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc_reg <= 32'sd0;
        end else begin
            if (state == LOAD) begin
                acc_reg <= 32'sd0;
            end else if (state == RUN && ctr_reg < 4'd8) begin
                acc_reg <= acc_next;
            end
            // Else hold value
        end
    end

    // Finally, assign product_reg and p when DONE:
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            product_reg <= 16'sd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            if (state == DONE) begin
                product_reg <= acc_reg[15:0]; // truncate final product to 16 bits (lower bits)
                p <= acc_reg[15:0];
                rdy <= 1'b1;
            end else if (state == LOAD) begin
                product_reg <= 16'sd0;
                p <= 16'd0;
                rdy <= 1'b0;
            end else if (state == RUN) begin
                // Hold outputs stable
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b0;
            end
        end
    end

endmodule