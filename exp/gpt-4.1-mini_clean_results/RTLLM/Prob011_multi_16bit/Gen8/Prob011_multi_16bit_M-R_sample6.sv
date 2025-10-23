module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // State definitions for FSM
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RUN  = 2'b01,
        DONE  = 2'b10
    } state_t;

    state_t state, next_state;

    reg [4:0]  i, i_next;
    reg [31:0] areg, areg_next;
    reg [15:0] breg, breg_next;
    reg [31:0] yout_r, yout_r_next;
    reg        done_r, done_r_next;

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if(start)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if(i == 5'd16)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                if(!start)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= IDLE;
            i       <= 5'd0;
            areg    <= 32'd0;
            breg    <= 16'd0;
            yout_r  <= 32'd0;
            done_r  <= 1'b0;
        end else begin
            state   <= next_state;
            i       <= i_next;
            areg    <= areg_next;
            breg    <= breg_next;
            yout_r  <= yout_r_next;
            done_r  <= done_r_next;
        end
    end

    // Combinational logic: next values
    always @(*) begin
        // Defaults: hold current values
        i_next       = i;
        areg_next    = areg;
        breg_next    = breg;
        yout_r_next  = yout_r;
        done_r_next  = done_r;

        case(state)
            IDLE: begin
                done_r_next = 1'b0;
                i_next      = 5'd0;
                if(start) begin
                    // Load inputs at start
                    areg_next   = {16'd0, ain};  // multiplicand in lower bits
                    breg_next   = bin;
                    yout_r_next = 32'd0;
                end else begin
                    areg_next   = 32'd0;
                    breg_next   = 16'd0;
                    yout_r_next = 32'd0;
                end
            end
            RUN: begin
                if (i < 5'd16) begin
                    // Check current bit of areg (multiplicand shifted by i)
                    if (areg[i]) 
                        yout_r_next = yout_r + (breg << i);

                    i_next = i + 5'd1;
                end else begin
                    // i == 16: done
                    done_r_next = 1'b1;
                end
            end
            DONE: begin
                done_r_next = 1'b1;
                if (!start) begin
                    done_r_next = 1'b0;
                    i_next      = 5'd0;
                    areg_next   = 32'd0;
                    breg_next   = 16'd0;
                    yout_r_next = 32'd0;
                end
            end
        endcase
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule