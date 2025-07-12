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
        MULT = 2'b10
    } state_t;

    state_t state, next_state;

    reg [4:0] i;           // shift count (0 to 16)
    reg [15:0] areg;       // multiplicand register
    reg [31:0] breg_ext;   // shifted multiplier register
    reg [31:0] yout_r;     // accumulated product

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = MULT;
            MULT: next_state = (i == 5'd16) ? IDLE : MULT;
            default: next_state = IDLE;
        endcase
    end

    // Shift count register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (state == MULT)
            i <= i + 5'd1;
        else
            i <= 5'd0;
    end

    // Data path registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    areg    <= 16'd0;
                    breg_ext <= 32'd0;
                    yout_r  <= 32'd0;
                end
                LOAD: begin
                    areg    <= ain;
                    breg_ext <= {16'd0, bin};
                    yout_r  <= 32'd0;
                end
                MULT: begin
                    // Accumulate if LSB of areg is 1
                    if (areg[0])
                        yout_r <= yout_r + breg_ext;
                    else
                        yout_r <= yout_r;

                    // Shift registers for next bit
                    areg    <= areg >> 1;
                    breg_ext <= breg_ext << 1;
                end
            endcase
        end
    end

    assign yout = yout_r;
    assign done = (state == IDLE) && (i == 5'd16);

endmodule