module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplicand input
    input      [7:0]  b,        // multiplier input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        RUN  = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    // Signed datapath registers
    reg signed [15:0] multiplicand;
    reg signed [15:0] multiplier;
    reg signed [15:0] product;

    reg [4:0] ctr;  // counts from 0 to 16

    // Control signals from FSM
    reg load_regs;
    reg add_enable;
    reg shift_multiplicand;
    reg [4:0] next_ctr;

    // Combinational logic: Next state and control signals
    always @(*) begin
        // Defaults
        next_state = state;
        load_regs = 1'b0;
        add_enable = 1'b0;
        shift_multiplicand = 1'b0;
        next_ctr = ctr;

        case (state)
            IDLE: begin
                if (!reset) begin
                    // Once reset released, load regs and start
                    load_regs = 1'b1;
                    next_state = RUN;
                    next_ctr = 5'd0;
                end
            end

            RUN: begin
                if (ctr < 5'd16) begin
                    // Check current bit of multiplier for addition enable
                    if (multiplier[ctr])
                        add_enable = 1'b1;
                    shift_multiplicand = 1'b1;
                    next_ctr = ctr + 1'b1;
                end else begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Hold DONE state and ready signal until reset
                next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: update state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= 16'sd0;
            multiplier <= 16'sd0;
            product <= 16'sd0;
            ctr <= 5'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;

            if (load_regs) begin
                multiplicand <= { {8{b[7]}}, b }; // multiplicand sign-extended from b
                multiplier <= { {8{a[7]}}, a };   // multiplier sign-extended from a
                product <= 16'sd0;
                ctr <= 5'd0;
                rdy <= 1'b0;
                p <= 16'd0;
            end else if (state == RUN) begin
                // Perform addition if bit is 1
                if (add_enable)
                    product <= product + multiplicand;

                // Shift multiplicand left by 1
                if (shift_multiplicand)
                    multiplicand <= multiplicand <<< 1;

                ctr <= next_ctr;
            end else if (state == DONE) begin
                rdy <= 1'b1;
                p <= product;
                // Hold registers, no change
            end
        end
    end

endmodule