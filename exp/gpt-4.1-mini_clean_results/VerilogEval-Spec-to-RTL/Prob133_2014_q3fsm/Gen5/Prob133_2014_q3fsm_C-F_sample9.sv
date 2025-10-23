module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0; // Wait for s=1
    localparam B = 1'b1; // Sampling w over 3 cycles and output

    reg state, next_state;
    reg [1:0] sample_count; // Counts 0..2: three sampling cycles
    reg [1:0] w_count;      // Counts how many times w=1 in current window

    // State register and counters sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state        <= A;
            sample_count <= 2'd0;
            w_count      <= 2'd0;
            z            <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    // Keep counters stable in state A
                    sample_count <= 2'd0;
                    w_count <= 2'd0;
                    z <= 1'b0; // output low in idle state
                end

                B: begin
                    if (sample_count < 2'd2) begin
                        // Sampling cycles: increment count and accumulate w
                        sample_count <= sample_count + 2'd1;
                        w_count <= w_count + w;
                        z <= 1'b0; // output low during sampling
                    end else begin
                        // Third sample cycle: add w, then output z next cycle
                        // Here sample_count == 2, add w to w_count, output z accordingly,
                        // then reset counters for next window
                        sample_count <= 2'd0;
                        w_count <= 2'd0;
                        // output z = 1 if exactly two w=1 samples in last 3 cycles (including this one)
                        z <= ((w_count + w) == 2) ? 1'b1 : 1'b0;
                    end
                end

                default: begin
                    state <= A;
                    sample_count <= 2'd0;
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            A:  next_state = (s == 1'b1) ? B : A;
            B:  next_state = B; // Remain in B indefinitely after entering
            default: next_state = A;
        endcase
    end

endmodule