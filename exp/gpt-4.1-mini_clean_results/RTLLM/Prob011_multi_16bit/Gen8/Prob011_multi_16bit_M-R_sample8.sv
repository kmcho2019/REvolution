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
        IDLE    = 2'b00,
        LOAD    = 2'b01,
        PROCESS = 2'b10,
        DONE    = 2'b11
    } state_t;

    state_t current_state, next_state;

    reg [4:0] i;              // shift counter: 0..16
    reg [15:0] areg;
    reg [31:0] breg_ext;
    reg [31:0] yout_r;
    reg done_r;

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:    next_state = start ? LOAD : IDLE;
            LOAD:    next_state = PROCESS;
            PROCESS: next_state = (i == 5'd16) ? DONE : PROCESS;
            DONE:    next_state = start ? DONE : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            i <= 5'd0;
            areg <= 16'd0;
            breg_ext <= 32'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    i <= 5'd0;
                    areg <= 16'd0;
                    breg_ext <= 32'd0;
                    yout_r <= 32'd0;
                    done_r <= 1'b0;
                end

                LOAD: begin
                    areg <= ain;
                    breg_ext <= {16'd0, bin};
                    yout_r <= 32'd0;
                    i <= 5'd0;
                    done_r <= 1'b0;
                end

                PROCESS: begin
                    // If LSB of areg is 1, add shifted multiplier to accumulator
                    if (areg[0])
                        yout_r <= yout_r + breg_ext;
                    // Shift registers for next bit
                    areg <= areg >> 1;
                    breg_ext <= breg_ext << 1;
                    i <= i + 5'd1;
                    done_r <= 1'b0;
                end

                DONE: begin
                    done_r <= 1'b1;
                    // Hold registers stable
                end

                default: begin
                    // Default safe values
                    i <= 5'd0;
                    areg <= 16'd0;
                    breg_ext <= 32'd0;
                    yout_r <= 32'd0;
                    done_r <= 1'b0;
                end
            endcase
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule