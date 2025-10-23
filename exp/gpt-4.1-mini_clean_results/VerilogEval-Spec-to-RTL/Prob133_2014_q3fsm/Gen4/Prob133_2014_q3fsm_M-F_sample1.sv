module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0; // Wait for s=1
    localparam B = 1'b1; // Sample w 3 times and output z

    reg state, next_state;

    reg [1:0] sample_cnt;    // counts number of w samples taken: 0..3
    reg [1:0] count_w;       // counts number of w=1 samples in current window

    reg [1:0] latched_count_w; // latched count_w after 3 samples
    reg z_pending;            // flag indicating output cycle for z

    // Sequential logic: state, counters, output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            sample_cnt <= 2'd0;
            count_w <= 2'd0;
            latched_count_w <= 2'd0;
            z_pending <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    // Reset counters and output in A
                    sample_cnt <= 2'd0;
                    count_w <= 2'd0;
                    latched_count_w <= 2'd0;
                    z_pending <= 1'b0;
                    z <= 1'b0;
                end

                B: begin
                    if (!z_pending) begin
                        // Sampling phase: accumulate w and increment sample count
                        count_w <= count_w + w;
                        sample_cnt <= sample_cnt + 1'b1;
                        z <= 1'b0;

                        if (sample_cnt == 2'd2) begin
                            // After 3 samples (counts 0,1,2), latch count_w + current w
                            latched_count_w <= count_w + w;
                            z_pending <= 1'b1;  // next cycle will output z
                        end
                    end else begin
                        // Output phase: output z based on latched count_w from previous sampling window
                        z <= (latched_count_w == 2);
                        // Reset counters for next sampling window
                        sample_cnt <= 2'd0;
                        count_w <= 2'd0;
                        latched_count_w <= 2'd0;
                        z_pending <= 1'b0;
                    end
                end

                default: begin
                    sample_cnt <= 2'd0;
                    count_w <= 2'd0;
                    latched_count_w <= 2'd0;
                    z_pending <= 1'b0;
                    z <= 1'b0;
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
                next_state = B; // remain in B forever sampling/outputting
            end

            default: next_state = A;
        endcase
    end

endmodule