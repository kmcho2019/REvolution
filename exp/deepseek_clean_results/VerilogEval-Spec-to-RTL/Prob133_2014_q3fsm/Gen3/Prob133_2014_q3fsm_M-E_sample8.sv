module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // FSM states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Shift register for last 3 w values
    reg [2:0] w_history;
    // Counter for evaluation timing (0-2)
    reg [1:0] cycle_cnt;
    // Evaluation flag (set when counter wraps)
    reg eval_flag;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b0;
            cycle_cnt <= 2'b0;
            eval_flag <= 1'b0;
            z <= 1'b0;
        end else begin
            // Default assignments
            eval_flag <= 1'b0;
            z <= 1'b0;

            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_history <= 3'b0;
                        cycle_cnt <= 2'b0;
                    end
                end
                B: begin
                    // Shift in new w value
                    w_history <= {w_history[1:0], w};

                    // Update cycle counter (modulo 3)
                    cycle_cnt <= (cycle_cnt == 2'b10) ? 2'b00 : (cycle_cnt + 1'b1);

                    // Set eval_flag when counter wraps
                    eval_flag <= (cycle_cnt == 2'b10);

                    // Output result from previous evaluation
                    if (eval_flag) begin
                        // Count number of 1's in w_history
                        case (w_history[0] + w_history[1] + w_history[2])
                            2: z <= 1'b1;  // Exactly two 1's
                            default: z <= 1'b0;
                        endcase
                    end
                end
            endcase
        end
    end

endmodule