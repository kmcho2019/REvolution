module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State definitions
    reg state;        // 0=A, 1=B
    reg [1:0] cycle_count;  // Counts 0-2 (3 cycles)
    reg [1:0] w_count;      // Counts w=1 occurrences

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;          // State A
            cycle_count <= 0;
            w_count <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin  // State A
                    z <= 0;
                    if (s) begin
                        state <= 1;  // Move to state B
                        cycle_count <= 0;
                        w_count <= 0;
                    end
                end
                1: begin  // State B
                    // Set z at start of new window based on previous count
                    if (cycle_count == 0) begin
                        z <= (w_count == 2);
                    end else begin
                        z <= 0;
                    end

                    // Count cycles and w values
                    if (cycle_count < 2) begin  // Only count w in first 2 cycles
                        if (w) begin
                            w_count <= w_count + 1;
                        end
                        cycle_count <= cycle_count + 1;
                    end else begin  // cycle_count == 2 (last cycle of window)
                        cycle_count <= 0;
                        w_count <= 0;  // Reset for next window
                    end
                end
            endcase
        end
    end

endmodule