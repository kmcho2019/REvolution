module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State definitions
    reg state;        // 0=A, 1=B
    reg [1:0] cycle;  // Tracks position in 3-cycle window
    reg [1:0] w_count;// Counts 1's in current window
    reg evaluate;     // Flag to evaluate in next cycle
    reg ones_count;   // Registered count of 1's (pipelined)

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            cycle <= 0;
            w_count <= 0;
            evaluate <= 0;
            z <= 0;
            ones_count <= 0;
        end else begin
            // Default assignments
            evaluate <= 0;
            z <= 0;

            case (state)
                0: begin // State A
                    if (s) begin
                        state <= 1;
                        cycle <= 0;
                        w_count <= 0;
                    end
                end
                
                1: begin // State B
                    // Update w_count only when needed
                    if (w) w_count <= w_count + 1;

                    // Update cycle counter
                    if (cycle == 2'd2) begin
                        cycle <= 0;
                        evaluate <= 1;
                        ones_count <= (w_count + w) == 2'd2; // Pre-calculate result
                        w_count <= 0;
                    end else begin
                        cycle <= cycle + 1;
                    end

                    // Output z one cycle after window completes
                    z <= evaluate && ones_count;
                end
            endcase
        end
    end

endmodule