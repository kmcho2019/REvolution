module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'd0, // Waiting for s=1
        B = 2'd1, // Sampling w for 3 cycles
        C = 2'd2  // Output z based on count_w
    } state_t;

    state_t state, next_state;

    reg [1:0] sample_cnt;  // counts samples taken in B state (0..2)
    reg [1:0] count_w;     // counts number of w=1 in current window

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            sample_cnt <= 2'd0;
            count_w <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    // stay here until s=1
                    z <= 1'b0;
                    sample_cnt <= 2'd0;
                    count_w <= 2'd0;
                end

                B: begin
                    // Accumulate count_w with current w
                    count_w <= count_w + (w ? 1'b1 : 1'b0);
                    sample_cnt <= sample_cnt + 1'b1;
                    z <= 1'b0;  // no output during sampling
                end

                C: begin
                    // Output z according to count_w == 2
                    z <= (count_w == 2);
                    // Reset counters for next window
                    sample_cnt <= 2'd0;
                    count_w <= 2'd0;
                end

                default: begin
                    z <= 1'b0;
                    sample_cnt <= 2'd0;
                    count_w <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            A: begin
                if (s == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                if (sample_cnt == 2'd2) // after 3 samples: 0,1,2
                    next_state = C;
                else
                    next_state = B;
            end

            C: begin
                // After output cycle, go back to sampling more w values
                next_state = B;
            end

            default: next_state = A;
        endcase
    end

endmodule