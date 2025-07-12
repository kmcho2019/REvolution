module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        LOAD = 2'd1,
        CALC = 2'd2
    } state_t;

    state_t current_state, next_state;

    reg [4:0] bit_cnt;         // counts 0 to 16
    reg [15:0] areg;
    reg [31:0] breg_ext;
    reg [31:0] yout_r;
    reg done_r;

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // FSM next-state logic
    always @(*) begin
        case (current_state)
            IDLE:  next_state = start ? LOAD : IDLE;
            LOAD:  next_state = CALC;
            CALC:  next_state = (bit_cnt == 5'd16) ? IDLE : CALC;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for registers and counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
            bit_cnt <= 5'd0;
            done_r  <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    areg    <= 16'd0;
                    breg_ext <= 32'd0;
                    yout_r  <= 32'd0;
                    bit_cnt <= 5'd0;
                    done_r  <= 1'b0;
                end
                LOAD: begin
                    areg    <= ain;
                    breg_ext <= {16'd0, bin}; // place multiplier in lower 16 bits
                    yout_r  <= 32'd0;
                    bit_cnt <= 5'd0;
                    done_r  <= 1'b0;
                end
                CALC: begin
                    if (bit_cnt < 5'd16) begin
                        // Accumulate if LSB of areg is 1
                        if (areg[0])
                            yout_r <= yout_r + breg_ext;
                        else
                            yout_r <= yout_r;
                        // Shift registers for next bit
                        areg <= areg >> 1;
                        breg_ext <= breg_ext << 1;
                        bit_cnt <= bit_cnt + 1'b1;
                        done_r <= 1'b0;
                    end else begin
                        // Completed multiplication
                        done_r <= 1'b1;
                        // Keep registers stable
                        areg <= areg;
                        breg_ext <= breg_ext;
                        yout_r <= yout_r;
                        bit_cnt <= bit_cnt;
                    end
                end
                default: begin
                    areg    <= 16'd0;
                    breg_ext <= 32'd0;
                    yout_r  <= 32'd0;
                    bit_cnt <= 5'd0;
                    done_r  <= 1'b0;
                end
            endcase
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule