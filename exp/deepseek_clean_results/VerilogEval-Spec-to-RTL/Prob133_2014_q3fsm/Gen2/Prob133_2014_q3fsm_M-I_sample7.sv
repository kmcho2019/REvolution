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
    // Counter for 3-cycle windows
    reg [1:0] cycle_count;
    // Evaluation flag (set when window is complete)
    reg evaluate;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            cycle_count <= 2'b00;
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
                        // Initialize first window
                        w_history <= {2'b00, w};
                        cycle_count <= 2'b01;
                    end
                end
                B: begin
                    // Shift in new w value
                    w_history <= {w_history[1:0], w};
                    
                    // Update cycle counter
                    if (cycle_count == 2'b10) begin
                        // Window complete - evaluate next cycle
                        evaluate <= 1'b1;
                        cycle_count <= 2'b00;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end

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