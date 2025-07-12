module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // Define states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Shift register for last 3 w values
    reg [2:0] w_history;
    // Flag to indicate when to evaluate
    reg evaluate;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            evaluate <= 1'b0;
            z <= 1'b0;
        end else begin
            // Default assignments
            evaluate <= 1'b0;
            z <= 1'b0;

            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_history <= {w_history[1:0], w}; // Start collecting
                    end
                end
                B: begin
                    // Shift in new w value
                    w_history <= {w_history[1:0], w};

                    // Set evaluate flag every 3rd cycle
                    evaluate <= (w_history[0] & ~w_history[1] & ~w_history[2]) || 
                               (~w_history[0] & w_history[1] & ~w_history[2]) ||
                               (~w_history[0] & ~w_history[1] & w_history[2]);

                    // Output result from previous evaluation
                    if (evaluate) begin
                        // Count number of 1's in previous window
                        case (w_history)
                            3'b011, 3'b101, 3'b110: z <= 1'b1;
                            default: z <= 1'b0;
                        endcase
                    end
                end
            endcase
        end
    end

endmodule