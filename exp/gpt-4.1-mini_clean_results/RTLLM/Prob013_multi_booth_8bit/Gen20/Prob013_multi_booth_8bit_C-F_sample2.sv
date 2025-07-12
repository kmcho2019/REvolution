module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,       // multiplier input
    input      [7:0]  b,       // multiplicand input
    output reg [15:0] p,       // product output
    output reg        rdy       // ready signal
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        CALC = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // Registers (signed 16-bit for correct signed operation)
    reg signed [15:0] multiplier_reg, multiplier_next;
    reg signed [15:0] multiplicand_reg, multiplicand_next;
    reg signed [15:0] product_reg, product_next;

    reg [4:0] ctr_reg, ctr_next; // counter for 0..15

    // Control signals
    reg load_enable;
    reg add_enable;
    reg shift_enable;

    // FSM next state and control signals
    always @(*) begin
        // Defaults
        next_state   = state;
        load_enable  = 1'b0;
        add_enable   = 1'b0;
        shift_enable = 1'b0;
        ctr_next    = ctr_reg;

        case (state)
            IDLE: begin
                // Wait for reset to deassert
                if (!reset)
                    next_state = LOAD;
            end

            LOAD: begin
                load_enable = 1'b1;
                ctr_next = 5'd0;
                next_state = CALC;
            end

            CALC: begin
                if (ctr_reg < 5'd16) begin
                    // Check multiplier bit at current counter
                    if (multiplier_reg[ctr_reg])
                        add_enable = 1'b1;

                    shift_enable = 1'b1;
                    ctr_next = ctr_reg + 1'b1;
                end else begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Datapath next values
    always @(*) begin
        // Defaults: hold current values
        multiplier_next   = multiplier_reg;
        multiplicand_next = multiplicand_reg;
        product_next      = product_reg;

        if (load_enable) begin
            // Load sign-extended inputs
            multiplier_next   = {{8{a[7]}}, a}; // multiplier from a
            multiplicand_next = {{8{b[7]}}, b}; // multiplicand from b
            product_next      = 16'sd0;
        end else if (state == CALC) begin
            // Conditional addition if add_enable asserted
            if (add_enable)
                product_next = product_reg + multiplicand_reg;

            // Shift multiplicand left if shift_enable asserted
            if (shift_enable)
                multiplicand_next = multiplicand_reg <<< 1;
        end
        // else hold registers
    end

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state           <= IDLE;
            multiplier_reg  <= 16'sd0;
            multiplicand_reg <= 16'sd0;
            product_reg     <= 16'sd0;
            ctr_reg         <= 5'd0;
            p               <= 16'd0;
            rdy             <= 1'b0;
        end else begin
            state    <= next_state;
            ctr_reg  <= ctr_next;

            // Update registers only on load or calc states
            if (load_enable || state == CALC) begin
                multiplier_reg  <= multiplier_next;
                multiplicand_reg <= multiplicand_next;
                product_reg     <= product_next;
            end

            // Ready and output control
            if (state == CALC && ctr_next == 5'd16) begin
                // Multiplication done
                p   <= product_next;
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;

                // Clear output on load
                if (load_enable)
                    p <= 16'd0;
            end
        end
    end

endmodule