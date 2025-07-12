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
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        CALC = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;
    reg [4:0] shift_cnt;         // Count 0 to 16
    reg [15:0] areg;
    reg [31:0] breg;
    reg [31:0] product;

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = start ? LOAD : IDLE;
            LOAD:  next_state = CALC;
            CALC:  next_state = (shift_cnt == 5'd16) ? DONE : CALC;
            DONE:  next_state = start ? LOAD : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // shift counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_cnt <= 5'd0;
        else if (state == LOAD)
            shift_cnt <= 5'd0;
        else if (state == CALC)
            shift_cnt <= shift_cnt + 5'd1;
        else
            shift_cnt <= 5'd0;
    end

    // Data path registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg    <= 32'd0;
            product <= 32'd0;
        end else begin
            case (state)
                LOAD: begin
                    areg    <= ain;
                    breg    <= {16'd0, bin};
                    product <= 32'd0;
                end
                CALC: begin
                    // Accumulate if LSB of areg is 1
                    if (areg[0])
                        product <= product + breg;
                    else
                        product <= product;
                    // Shift registers for next bit
                    areg <= areg >> 1;
                    breg <= breg << 1;
                end
                default: begin
                    // Hold registers
                    areg    <= areg;
                    breg    <= breg;
                    product <= product;
                end
            endcase
        end
    end

    // Done flag output
    assign done = (state == DONE);
    // Product output
    assign yout = product;

endmodule