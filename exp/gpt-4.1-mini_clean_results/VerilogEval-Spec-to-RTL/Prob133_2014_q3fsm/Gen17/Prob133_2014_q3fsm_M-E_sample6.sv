module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding (1 bit)
    localparam A = 1'b0; // Wait for s=1
    localparam B = 1'b1; // Sampling state

    reg state, next_state;

    reg [1:0] sample_idx;  // counts 0 to 2 for the 3 samples
    reg [1:0] w_count;     // counts how many times w=1 in 3 samples

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state      <= A;
            sample_idx <= 2'b00;
            w_count    <= 2'b00;
            z          <= 1'b0;
        end else begin
            state <= next_state;

            if (state == A) begin
                // Reset counters in A state
                sample_idx <= 2'b00;
                w_count    <= 2'b00;
                z          <= 1'b0;
            end else begin
                // In B state: sample w and count
                if (sample_idx < 2'd2) begin
                    // Accumulate count during first two samples
                    w_count <= w_count + (w ? 2'b01 : 2'b00);
                    sample_idx <= sample_idx + 1'b1;
                    z <= 1'b0;
                end else begin
                    // Third sample: add w, then assert z next cycle
                    w_count <= 2'b00;   // Reset w_count for next window
                    sample_idx <= 2'b00;

                    // Output z registered here for previous window:
                    // z = 1 if (w_count + w == 2), else 0
                    // Compute sum as 3-bit to prevent overflow
                    if ((w_count + (w ? 2'b01 : 2'b00)) == 2)
                        z <= 1'b1;
                    else
                        z <= 1'b0;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = B; // stay in B indefinitely once entered
            default: next_state = A;
        endcase
    end

endmodule