module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding for consecutive one counts plus error state
    typedef enum logic [3:0] {
        s0 = 4'd0,
        s1 = 4'd1,
        s2 = 4'd2,
        s3 = 4'd3,
        s4 = 4'd4,
        s5 = 4'd5,
        s6 = 4'd6,
        err_out = 4'd7
    } state_t;

    state_t curr_state, next_state;

    // Registers for outputs to produce one-cycle delayed Moore outputs
    reg disc_r, flag_r, err_r;

    // Next state logic combinational
    always @(*) begin
        case(curr_state)
            s0: next_state = in ? s1 : s0;
            s1: next_state = in ? s2 : s0;
            s2: next_state = in ? s3 : s0;
            s3: next_state = in ? s4 : s0;
            s4: next_state = in ? s5 : s0;
            s5: next_state = in ? s6 : s0; // 5 consecutive ones + in=1 -> 6 ones
            s6: begin
                if(in)
                    next_state = err_out; // 7 consecutive ones detected -> error
                else
                    next_state = s0;      // 6 ones followed by 0
            end
            err_out: next_state = in ? err_out : s0; // stay err_out on ones, else reset
            default: next_state = s0;
        endcase
    end

    // Output and state registers - synchronous logic with synchronous active-high reset
    always @(posedge clk) begin
        if(reset) begin
            curr_state <= s0;
            disc_r <= 1'b0;
            flag_r <= 1'b0;
            err_r  <= 1'b0;
        end else begin
            curr_state <= next_state;

            // Default outputs off; set below if conditions met
            disc_r <= 1'b0;
            flag_r <= 1'b0;
            err_r  <= 1'b0;

            // Outputs asserted for one full cycle after detection (Moore FSM style)
            case(curr_state)
                s5: if (~in) disc_r <= 1'b1; // After detecting 5 ones, next input=0 -> discard zero next cycle
                s6: if (~in) flag_r <= 1'b1; // After detecting 6 ones, next input=0 -> flag next cycle
                err_out: err_r <= 1'b1;      // Error asserted continuously in err_out
                default: ;
            endcase
        end
    end

    // Assign outputs from registers
    assign disc = disc_r;
    assign flag = flag_r;
    assign err  = err_r;

endmodule