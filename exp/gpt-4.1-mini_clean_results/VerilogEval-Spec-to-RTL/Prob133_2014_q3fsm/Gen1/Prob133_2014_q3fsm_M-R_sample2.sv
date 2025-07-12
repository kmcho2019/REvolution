module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    reg [1:0] cycle_count;   // Counts cycles in B (0 to 2)
    reg [1:0] w_count;       // Counts how many times w=1 in current 3-cycle window

    reg z_pending;           // Flag indicating z should be asserted this cycle

    // Sequential block: state transitions, counters, and output logic
    always @(posedge clk) begin
        if (reset) begin
            state       <= A;
            cycle_count <= 2'd0;
            w_count     <= 2'd0;
            z_pending   <= 1'b0;
            z           <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    // In state A, output zero and clear counters
                    z_pending   <= 1'b0;
                    z           <= 1'b0;
                    cycle_count <= 2'd0;
                    w_count     <= 2'd0;
                end

                B: begin
                    z <= z_pending;  // Output z if pending from previous window
                    z_pending <= 1'b0; // Clear pending after output

                    if (cycle_count == 2) begin
                        // End of 3rd cycle: set z_pending for next cycle based on w_count + current w
                        // Count current w for this cycle
                        // Because w_count contains sum of previous two cycles,
                        // total_ones = w_count + w (0 or 1)
                        if ((w_count + w) == 2)
                            z_pending <= 1'b1;
                        else
                            z_pending <= 1'b0;

                        // Reset counters for next window
                        cycle_count <= 2'd0;
                        w_count     <= 2'd0;
                    end else begin
                        // Middle of window: increment cycle count and accumulate w_count
                        cycle_count <= cycle_count + 1'b1;
                        w_count <= w_count + w;
                    end
                end

                default: begin
                    // Defensive: go to state A
                    state       <= A;
                    cycle_count <= 2'd0;
                    w_count     <= 2'd0;
                    z_pending   <= 1'b0;
                    z           <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: begin
                if (s == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                next_state = B; // Remain in B forever after entering
            end

            default: next_state = A;
        endcase
    end

endmodule