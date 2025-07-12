module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplier input
    input      [7:0]  b,        // multiplicand input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // FSM states definition
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        RUN  = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    // Registers for signed 16-bit values
    reg signed [15:0] multiplicand_reg, multiplicand_next;
    reg signed [15:0] multiplier_reg, multiplier_next;
    reg signed [15:0] product_reg, product_next;

    reg [4:0] ctr_reg, ctr_next;

    // Control signals
    reg load_regs;
    reg add_enable;
    reg shift_enable;

    // Combinational FSM and control logic
    always @(*) begin
        // Defaults
        next_state = state;
        load_regs = 1'b0;
        add_enable = 1'b0;
        shift_enable = 1'b0;
        ctr_next = ctr_reg;

        case (state)
            IDLE: begin
                if (!reset) begin
                    next_state = LOAD;
                end
            end

            LOAD: begin
                load_regs = 1'b1;
                next_state = RUN;
                ctr_next = 5'd0;
            end

            RUN: begin
                if (ctr_reg < 5'd16) begin
                    // Check multiplier bit for addition
                    if (multiplier_reg[ctr_reg])
                        add_enable = 1'b1;

                    shift_enable = 1'b1;
                    ctr_next = ctr_reg + 1'b1;
                end else begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Stay in DONE until reset
                next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Combinational datapath next-state logic
    always @(*) begin
        // Default: hold values
        multiplier_next = multiplier_reg;
        multiplicand_next = multiplicand_reg;
        product_next = product_reg;

        if (load_regs) begin
            // Load inputs with sign extension (per problem description)
            multiplier_next = { {8{a[7]}}, a };     // multiplier from a
            multiplicand_next = { {8{b[7]}}, b };   // multiplicand from b
            product_next = 16'sd0;
        end else if (state == RUN) begin
            // Add multiplicand to product if multiplier bit is 1
            if (add_enable)
                product_next = product_reg + multiplicand_reg;
            // Shift multiplicand left by 1 bit
            if (shift_enable)
                multiplicand_next = multiplicand_reg <<< 1;
        end
        // In other states, hold registers
    end

    // Sequential logic: register update and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            multiplicand_reg <= 16'sd0;
            multiplier_reg <= 16'sd0;
            product_reg <= 16'sd0;
            ctr_reg <= 5'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;

            if (load_regs || state == RUN) begin
                multiplier_reg <= multiplier_next;
                multiplicand_reg <= multiplicand_next;
                product_reg <= product_next;
            end

            ctr_reg <= ctr_next;

            if (next_state == DONE) begin
                p <= product_reg;
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;
                if (next_state == LOAD)
                    p <= 16'd0;  // clear output on new load
            end
        end
    end

endmodule