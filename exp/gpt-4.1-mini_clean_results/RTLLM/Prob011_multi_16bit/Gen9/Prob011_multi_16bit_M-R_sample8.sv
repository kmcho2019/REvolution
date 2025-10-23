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
    localparam IDLE = 1'b0;
    localparam RUN  = 1'b1;

    reg state, next_state;
    reg [4:0] i;               // shift counter: counts 0 to 16
    reg [15:0] areg;           // multiplicand shift register
    reg [31:0] breg_ext;       // multiplier extended and shifted register
    reg [31:0] yout_r;         // product accumulator
    reg done_r;

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (start)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if (i == 5'd16)
                    next_state = IDLE;
                else
                    next_state = RUN;
            end
            default: next_state = IDLE;
        endcase
    end

    // Shift counter and registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i        <= 5'd0;
            areg     <= 16'd0;
            breg_ext <= 32'd0;
            yout_r   <= 32'd0;
            done_r   <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    i      <= 5'd0;
                    yout_r <= 32'd0;
                    done_r <= 1'b0;
                    if (start) begin
                        areg     <= ain;
                        breg_ext <= {16'd0, bin};
                    end else begin
                        areg     <= 16'd0;
                        breg_ext <= 32'd0;
                    end
                end
                RUN: begin
                    done_r <= 1'b0;
                    if (areg[0])
                        yout_r <= yout_r + breg_ext;
                    else
                        yout_r <= yout_r;

                    // Shift multiplicand right, multiplier left
                    areg     <= areg >> 1;
                    breg_ext <= breg_ext << 1;

                    i <= i + 5'd1;

                    if (i == 5'd15) // done at next cycle (i=16)
                        done_r <= 1'b1;
                end
            endcase
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule