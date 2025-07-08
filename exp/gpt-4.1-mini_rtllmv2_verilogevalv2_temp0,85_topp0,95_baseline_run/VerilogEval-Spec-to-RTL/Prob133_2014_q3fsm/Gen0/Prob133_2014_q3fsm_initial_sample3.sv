module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A = 2'd0;
    localparam B = 2'd1;
    localparam C = 2'd2;

    reg [1:0] state, next_state;

    // Counters
    reg [1:0] w_count;    // Counts how many times w=1 in the 3 cycle window
    reg [1:0] cycle_cnt;  // Counts the number of w samples taken (0 to 2)

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 0;
            cycle_cnt <= 0;
            z <= 0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    z <= 0;
                    w_count <= 0;
                    cycle_cnt <= 0;
                end

                B: begin
                    // Count w=1
                    if (w)
                        w_count <= w_count + 1;

                    // Increment cycle count
                    cycle_cnt <= cycle_cnt + 1;

                    z <= 0;
                end

                C: begin
                    // Output z=1 if exactly two w=1 in previous 3 cycles
                    z <= (w_count == 2) ? 1'b1 : 1'b0;
                    // Clear counters to start next measurement
                    w_count <= 0;
                    cycle_cnt <= 0;
                end

                default: begin
                    z <= 0;
                    w_count <= 0;
                    cycle_cnt <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                if (cycle_cnt == 2) // after collecting 3 samples (0,1,2)
                    next_state = C;
                else
                    next_state = B;
            end

            C: begin
                // After outputting z for 1 cycle, go back to B for next 3 samples
                next_state = B;
            end

            default: next_state = A;
        endcase
    end

endmodule