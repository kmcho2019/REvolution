module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State declaration
    typedef enum reg {A, B} state_t;
    state_t state, next_state;

    reg [1:0] cycle_count;   // counts number of samples taken (0 to 3)
    reg [1:0] w_count;       // counts number of w=1 in current 3-cycle window
    reg z_next;              // holds z value to be output next cycle (one-cycle delayed z)

    // Sequential logic: state update, counters, and output z
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 0;
            w_count <= 0;
            z <= 0;
            z_next <= 0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    // In state A: reset counters and outputs
                    cycle_count <= 0;
                    w_count <= 0;
                    z <= 0;
                    z_next <= 0;
                end

                B: begin
                    if (cycle_count < 3) begin
                        // Sample w inputs, increment counters
                        cycle_count <= cycle_count + 1;
                        w_count <= w_count + w;
                        // Output z is previous z_next value (one cycle delayed)
                        z <= z_next;
                        z_next <= 0; // clear z_next while sampling
                    end else begin
                        // cycle_count == 3: finished 3 samples
                        // Compute z_next based on w_count == 2
                        z_next <= (w_count == 2) ? 1'b1 : 1'b0;

                        // Reset cycle_count and w_count for next window
                        cycle_count <= 1;   // count current w as first sample of next window
                        w_count <= w;

                        // Output the previous z_next (assert z now if z_next was set last cycle)
                        z <= z_next;
                    end
                end

                default: begin
                    // Should not occur, reset state machine
                    state <= A;
                    cycle_count <= 0;
                    w_count <= 0;
                    z <= 0;
                    z_next <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                next_state = B;
            end

            default: next_state = A;
        endcase
    end

endmodule