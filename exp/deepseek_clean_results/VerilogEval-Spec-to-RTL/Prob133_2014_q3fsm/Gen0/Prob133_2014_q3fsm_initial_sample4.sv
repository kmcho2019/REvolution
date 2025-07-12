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

    // Counters for B state
    reg [1:0] cycle_count;  // Tracks 0-2 cycles
    reg [1:0] w_count;      // Counts w=1 occurrences

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
            cycle_count <= 0;
            w_count <= 0;
        end else begin
            case (state)
                A: begin
                    z <= 0;
                    if (s) begin
                        state <= B;
                        cycle_count <= 0;
                        w_count <= 0;
                    end
                end
                B: begin
                    // Count w in first two cycles
                    if (cycle_count < 2) begin
                        if (w) w_count <= w_count + 1;
                        cycle_count <= cycle_count + 1;
                        z <= 0;
                    end
                    // Third cycle - evaluate and output
                    else begin
                        // Count this cycle's w
                        if (w) w_count <= w_count + 1;
                        
                        // Set output based on count
                        z <= (w_count == 2'd2);
                        
                        // Reset for next 3-cycle window
                        cycle_count <= 0;
                        w_count <= 0;
                    end
                end
            endcase
        end
    end

endmodule