module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;

    reg state, next_state;

    // In STATE_B: track number of cycles (0,1,2) and number of w=1 counts (0..3)
    reg [1:0] cycle_count;    // counts 0,1,2
    reg [1:0] w_count;        // counts number of w=1 in current 3-cycle window
    reg z_next;               // next value of z to output

    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset
            state <= STATE_A;
            cycle_count <= 0;
            w_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;

            if (state == STATE_A) begin
                // In state A, no counting, z=0
                cycle_count <= 0;
                w_count <= 0;
                z <= 0;
            end else begin
                // state B behavior
                if (cycle_count < 2) begin
                    // Within the 3-cycle window, increment counters
                    cycle_count <= cycle_count + 1;

                    // Count w=1 occurrences
                    if (w)
                        w_count <= w_count + 1;

                    // z remains previous (z only updated after 3 cycles)
                    z <= 0;
                end else begin
                    // cycle_count == 2, last cycle of window

                    // Count w input in this cycle
                    if (w)
                        w_count <= w_count + 1;

                    // After this cycle, output z in next clock cycle according to count
                    // So here, we latch z=1 if w_count+current w==2 else 0
                    z <= ((w_count + (w ? 1 : 0)) == 2) ? 1'b1 : 1'b0;

                    // reset cycle and w count for next window
                    cycle_count <= 0;
                    w_count <= 0;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            STATE_A: begin
                if (s == 1'b1)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            STATE_B: begin
                // Remain in B forever
                next_state = STATE_B;
            end
            default: next_state = STATE_A;
        endcase
    end

endmodule