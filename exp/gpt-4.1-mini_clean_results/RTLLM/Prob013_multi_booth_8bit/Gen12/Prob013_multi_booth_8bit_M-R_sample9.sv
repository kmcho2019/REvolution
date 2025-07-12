module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,       // multiplier input
    input      [7:0]   b,       // multiplicand input
    output reg [15:0]  p,       // product output
    output reg         rdy       // ready signal
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        CALC = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // Signed registers
    reg signed [15:0] multiplier_reg, multiplicand_reg, product_reg;
    reg [4:0]         ctr_reg, ctr_next;

    // Next values for registers
    reg signed [15:0] multiplier_next, multiplicand_next, product_next;

    // Next values for outputs
    reg               rdy_next;
    reg [15:0]        p_next;

    // Combinational next state and next data logic
    always @(*) begin
        // Default assignments
        next_state      = state;
        multiplier_next = multiplier_reg;
        multiplicand_next = multiplicand_reg;
        product_next    = product_reg;
        ctr_next        = ctr_reg;
        rdy_next        = rdy;
        p_next          = p;

        case(state)
            IDLE: begin
                rdy_next = 1'b0;
                p_next = 16'd0;
                if (!reset) begin
                    next_state = LOAD;
                end
            end

            LOAD: begin
                // Load inputs with sign extension
                multiplier_next = {{8{a[7]}}, a};
                multiplicand_next = {{8{b[7]}}, b};
                product_next = 16'sd0;
                ctr_next = 5'd0;
                rdy_next = 1'b0;
                p_next = 16'd0;

                next_state = CALC;
            end

            CALC: begin
                if (ctr_reg < 5'd16) begin
                    // Check bit ctr in multiplier
                    if (multiplier_reg[ctr_reg])
                        product_next = product_reg + multiplicand_reg;
                    else
                        product_next = product_reg;

                    multiplicand_next = multiplicand_reg <<< 1;
                    ctr_next = ctr_reg + 1'b1;
                    rdy_next = 1'b0;
                end else begin
                    // Finished multiplication
                    p_next = product_reg;
                    rdy_next = 1'b1;
                    // Stay in CALC until reset
                    multiplicand_next = multiplicand_reg;
                    product_next = product_reg;
                    ctr_next = ctr_reg;
                end
            end

            default: begin
                next_state = IDLE;
                rdy_next = 1'b0;
                p_next = 16'd0;
                multiplier_next = 16'sd0;
                multiplicand_next = 16'sd0;
                product_next = 16'sd0;
                ctr_next = 5'd0;
            end
        endcase
    end

    // Sequential logic: register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            multiplier_reg <= 16'sd0;
            multiplicand_reg <= 16'sd0;
            product_reg <= 16'sd0;
            ctr_reg <= 5'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            state <= next_state;
            multiplier_reg <= multiplier_next;
            multiplicand_reg <= multiplicand_next;
            product_reg <= product_next;
            ctr_reg <= ctr_next;
            rdy <= rdy_next;
            p <= p_next;
        end
    end

endmodule