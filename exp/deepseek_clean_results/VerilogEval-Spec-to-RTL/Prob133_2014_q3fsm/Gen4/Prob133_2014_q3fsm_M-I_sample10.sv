module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;         // 0=A, 1=B
    reg [2:0] cnt_w;   // Combined counter and w shift register
    reg evaluate;      // Flag to evaluate in next cycle

    // Optimized population count (2-bit result)
    wire [1:0] ones_count = ((cnt_w[0] + cnt_w[1]) + cnt_w[2]);
    assign z = evaluate && (ones_count == 2'd2);

    // Clock gating signal (only update cnt_w in state B)
    wire update_cnt_w = state && ~reset;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            cnt_w <= 0;
            evaluate <= 0;
        end else begin
            // Default clear evaluate flag
            evaluate <= 0;

            case (state)
                0: begin // State A
                    if (s) begin
                        state <= 1;
                        cnt_w <= 0;
                    end
                end
                
                1: begin // State B
                    if (update_cnt_w) begin
                        // Shift in new w value and increment counter
                        cnt_w <= {cnt_w[1:0], w};

                        // Set evaluate flag at end of window (every 3rd cycle)
                        if (&cnt_w[1:0]) begin  // Equivalent to counter == 2
                            evaluate <= 1;
                        end
                    end
                end
            endcase
        end
    end

endmodule