module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplier input
    input      [7:0]  b,      // multiplicand input
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        CALC = 2'b10
    } state_t;

    state_t state, next_state;

    // Signed 16-bit registers for multiplier, multiplicand, product
    reg signed [15:0] multiplier_reg, multiplier_next;
    reg signed [15:0] multiplicand_reg, multiplicand_next;
    reg signed [15:0] product_reg, product_next;

    // 5-bit cycle counter (0 to 15)
    reg [4:0] ctr_reg, ctr_next;

    // Control signals
    reg load_enable;
    reg add_enable;
    reg shift_enable;

    // FSM and control signals combinational logic
    always @(*) begin
        // Default values
        next_state   = state;
        load_enable  = 1'b0;
        add_enable   = 1'b0;
        shift_enable = 1'b0;
        ctr_next     = ctr_reg;

        case(state)
            IDLE: begin
                if (!reset) 
                    next_state = LOAD;
            end

            LOAD: begin
                load_enable = 1'b1;
                ctr_next    = 5'd0;
                next_state  = CALC;
            end

            CALC: begin
                if (ctr_reg < 5'd16) begin
                    // If multiplier bit at ctr is 1, enable add
                    if (multiplier_reg[ctr_reg])
                        add_enable = 1'b1;

                    // Shift multiplicand left every cycle
                    shift_enable = 1'b1;

                    // Increment counter
                    ctr_next = ctr_reg + 1'b1;
                end else begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Datapath next state combinational logic
    always @(*) begin
        // Default hold
        multiplier_next   = multiplier_reg;
        multiplicand_next = multiplicand_reg;
        product_next      = product_reg;

        if (load_enable) begin
            // Load inputs with sign-extension
            multiplier_next   = {{8{a[7]}}, a}; // multiplier from input a
            multiplicand_next = {{8{b[7]}}, b}; // multiplicand from input b
            product_next      = 16'sd0;
        end else if (state == CALC) begin
            if (add_enable)
                product_next = product_reg + multiplicand_reg;

            if (shift_enable)
                multiplicand_next = multiplicand_reg <<< 1;
        end
        // else hold values
    end

    // Sequential logic: state and registers update on clock posedge
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
            state       <= next_state;
            ctr_reg     <= ctr_next;

            if (load_enable || state == CALC) begin
                multiplier_reg  <= multiplier_next;
                multiplicand_reg <= multiplicand_next;
                product_reg     <= product_next;
            end

            // Update output and ready signals
            if ((state == CALC) && (ctr_next == 5'd16)) begin
                p   <= product_next;
                rdy <= 1'b1;
            end else begin
                // Clear ready and product output when not done or loading
                rdy <= 1'b0;
                if (load_enable)
                    p <= 16'd0;
            end
        end
    end

endmodule