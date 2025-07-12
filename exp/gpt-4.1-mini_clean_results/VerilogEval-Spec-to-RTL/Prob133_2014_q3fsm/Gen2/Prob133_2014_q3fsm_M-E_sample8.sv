module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0, B = 1'b1;

    reg state;

    // 3-bit shift register to hold w samples
    reg [2:0] w_samples;

    // Counts how many samples collected (0 to 3)
    reg [1:0] sample_count;

    // Number of 1's in w_samples, calculated combinationally
    wire [1:0] ones_count;

    assign ones_count = w_samples[0] + w_samples[1] + w_samples[2];

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_samples <= 3'b000;
            sample_count <= 2'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    sample_count <= 2'd0;
                    w_samples <= 3'b000;
                    if (s == 1'b1) begin
                        state <= B;
                        // Start collecting w samples next cycle
                    end
                end

                B: begin
                    z <= 1'b0; // default output

                    // Shift in new w sample
                    w_samples <= {w_samples[1:0], w};

                    // Increment sample count (max 3)
                    if (sample_count < 2'd3) begin
                        sample_count <= sample_count + 1'b1;
                    end

                    // After collecting 3 samples, output z next cycle
                    // To achieve output one cycle after 3rd sample, we separate logic:

                    if (sample_count == 2'd3) begin
                        // On this cycle, we have just shifted in the 3rd sample,
                        // so output must be asserted next cycle.
                        // To implement output delay, we'll register z based on previous window.

                        // Thus we use a small pipeline:
                        // We'll introduce an intermediate register to hold z for output next cycle.

                        // We'll implement this below outside this always block.
                    end
                end

                default: begin
                    state <= A;
                    w_samples <= 3'b000;
                    sample_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

    // To produce z one cycle after collecting 3 samples, we use a small pipeline register:
    reg z_next;            // calculated output based on w_samples at sample_count==3
    reg sample_complete_d; // delayed signal indicating sample_count==3 occurred previous cycle

    always @(posedge clk) begin
        if (reset) begin
            z_next <= 1'b0;
            sample_complete_d <= 1'b0;
            z <= 1'b0;
            sample_count <= 2'd0;
        end else begin
            if (state == B) begin
                // Detect when sample_count reaches 3: means current sample window done
                if (sample_count == 2'd3 && sample_complete_d == 1'b0) begin
                    // sample_complete_d=0 and sample_count=3 means new complete window
                    z_next <= (ones_count == 2) ? 1'b1 : 1'b0;
                    sample_complete_d <= 1'b1;
                    // Reset sample_count to 0 to start next window
                    sample_count <= 2'd0;
                end else if (sample_complete_d) begin
                    // output z_next for one cycle
                    z <= z_next;
                    sample_complete_d <= 1'b0;
                end else begin
                    // no output in sampling cycles
                    z <= 1'b0;
                end
            end else begin
                // In state A, reset pipeline regs and output z=0
                z <= 1'b0;
                z_next <= 1'b0;
                sample_complete_d <= 1'b0;
                sample_count <= 2'd0;
            end
        end
    end

endmodule