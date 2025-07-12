module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0; // Waiting for s=1
    localparam B = 1'b1; // Sampling w over 3 cycles

    reg state, next_state;

    reg [1:0] sample_count;  // Counts 0..2 for three sampling cycles
    reg [1:0] w_count;       // Accumulates number of w=1 samples in current window

    reg z_next;  // Next value for z to register synchronously

    // Sequential logic: state, counters, output
    always @(posedge clk) begin
        if (reset) begin
            state        <= A;
            sample_count <= 2'd0;
            w_count      <= 2'd0;
            z            <= 1'b0;
        end else begin
            state        <= next_state;

            case(state)
                A: begin
                    // Idle state, reset counters and output
                    sample_count <= 2'd0;
                    w_count      <= 2'd0;
                    z            <= 1'b0;
                end

                B: begin
                    if (sample_count < 2'd2) begin
                        // During sampling: increment counters
                        sample_count <= sample_count + 2'd1;
                        w_count <= w_count + w;
                        z <= 1'b0; // Output z is 0 during sampling
                    end else begin
                        // sample_count == 2: last sample cycle completed this clock
                        // In this cycle, add w to w_count and output z based on previous window
                        w_count <= 2'd0;      // Reset for next window
                        sample_count <= 2'd0; // Reset sample count for next window
                        // Assert z=1 if w_count + w == 2, else 0
                        z <= ((w_count + w) == 2) ? 1'b1 : 1'b0;
                    end
                end

                default: begin
                    // Should not happen, reset to safe state
                    state        <= A;
                    sample_count <= 2'd0;
                    w_count      <= 2'd0;
                    z            <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A:  next_state = (s == 1'b1) ? B : A;
            B:  next_state = B; // Stay in B until reset or next reset
            default: next_state = A;
        endcase
    end

endmodule