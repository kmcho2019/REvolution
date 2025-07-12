module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplier input
    input      [7:0]  b,        // multiplicand input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // FSM states definition (3 states as in Example 1)
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        CALC = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // Registers for signed 16-bit values
    reg signed [15:0] multiplicand_reg, multiplicand_next;
    reg signed [15:0] multiplier_reg, multiplier_next;
    reg signed [15:0] product_reg, product_next;

    reg [4:0] ctr_reg, ctr_next;  // 5-bit counter for 16 cycles

    // Control signals
    reg load_regs;
    reg add_enable;
    reg shift_enable;

    // Combinational FSM and control signal generation
    always @(*) begin
        // Default assignments
        next_state = state;
        load_regs = 1'b0;
        add_enable = 1'b0;
        shift_enable = 1'b0;
        ctr_next = ctr_reg;

        case (state)
            IDLE: begin
                // Wait until reset is deasserted to move to LOAD
                if (!reset) begin
                    next_state = LOAD;
                end
            end

            LOAD: begin
                load_regs = 1'b1;
                ctr_next = 5'd0;
                next_state = CALC;
            end

            CALC: begin
                if (ctr_reg < 5'd16) begin
                    // Check multiplier bit at ctr_reg to enable add
                    if (multiplier_reg[ctr_reg])
                        add_enable = 1'b1;

                    shift_enable = 1'b1;
                    ctr_next = ctr_reg + 1'b1;
                end else begin
                    // Multiplication done
                    next_state = IDLE; // Return to IDLE, waiting for reset again
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Combinational datapath next-state logic
    always @(*) begin
        // Default: hold current values
        multiplier_next = multiplier_reg;
        multiplicand_next = multiplicand_reg;
        product_next = product_reg;

        if (load_regs) begin
            // Load inputs with sign extension (a -> multiplier, b -> multiplicand)
            multiplier_next = { {8{a[7]}}, a };
            multiplicand_next = { {8{b[7]}}, b };
            product_next = 16'sd0;
        end
        else if (state == CALC) begin
            // Add multiplicand to product if multiplier bit is set
            if (add_enable)
                product_next = product_reg + multiplicand_reg;

            // Shift multiplicand left by 1 bit every cycle during CALC
            if (shift_enable)
                multiplicand_next = multiplicand_reg <<< 1;
        end
        // In other states hold registers
    end

    // Sequential logic: registers update and output logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers and outputs
            state <= IDLE;
            multiplicand_reg <= 16'sd0;
            multiplier_reg <= 16'sd0;
            product_reg <= 16'sd0;
            ctr_reg <= 5'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;

            // Register updates only when active (load or calc)
            if (load_regs || state == CALC) begin
                multiplier_reg <= multiplier_next;
                multiplicand_reg <= multiplicand_next;
                product_reg <= product_next;
            end

            ctr_reg <= ctr_next;

            // Output and ready signal logic:
            // rdy is asserted only when counter reaches 16 (multiplication done)
            if (state == CALC && ctr_next == 5'd16) begin
                p <= product_next;
                rdy <= 1'b1;
            end else begin
                // Clear ready and product when not done
                rdy <= 1'b0;
                if (load_regs)
                    p <= 16'd0; // Clear output on new load
            end
        end
    end

endmodule