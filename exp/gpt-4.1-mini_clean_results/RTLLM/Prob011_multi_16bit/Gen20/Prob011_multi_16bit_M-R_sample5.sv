module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // FSM states
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        RUNNING = 1'b1
    } state_t;

    state_t state, next_state;

    reg [4:0] count;             // Shift count: 0 to 16
    reg [31:0] product;          // Accumulator for partial sum
    reg [15:0] multiplier_reg;   // Shift register for multiplier bits
    reg done_reg;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:    next_state = start ? RUNNING : IDLE;
            RUNNING: next_state = (count == 5'd16) ? IDLE : RUNNING;
            default: next_state = IDLE;
        endcase
    end

    // Control: State, count, done flag
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            if (state == IDLE) begin
                done_reg <= 1'b0;
                count <= 5'd0;
            end else if (state == RUNNING) begin
                count <= count + 1'b1;
                done_reg <= (count == 5'd15);
            end
        end
    end

    // Data path: Load inputs at start and do shift-and-accumulate in RUNNING state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 32'd0;
            multiplier_reg <= 16'd0;
        end else if (state == IDLE) begin
            if (start) begin
                product <= 32'd0;
                multiplier_reg <= bin;
            end
        end else if (state == RUNNING) begin
            if (multiplier_reg[0]) begin
                // Add multiplicand shifted by count to product
                product <= product + ( {16'd0, ain} << count );
            end
            // Shift multiplier right by 1 bit
            multiplier_reg <= multiplier_reg >> 1;
        end
    end

    assign yout = product;
    assign done = done_reg;

endmodule