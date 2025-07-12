module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {A=2'd0, B=2'd1, C=2'd2} state_t;
    state_t state, next_state;

    reg [1:0] sample_cnt; // counts 0..2 for the three sample cycles
    reg [1:0] count_w;    // counts how many w=1 in sample window

    // State transition and output logic
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
                    z <= 1'b0;
                    sample_cnt <= 2'd0;
                    count_w <= 2'd0;
                end
                B: begin
                    // Accumulate w count for this sample
                    count_w <= count_w + w;

                    if (sample_cnt == 2'd2) begin
                        // Completed 3 samples (0,1,2)
                        sample_cnt <= 2'd0;
                    end else begin
                        sample_cnt <= sample_cnt + 1'b1;
                    end

                    z <= 1'b0; // no output in sampling state
                end
                C: begin
                    // Output z=1 if exactly two w=1 counted, else 0
                    z <= (count_w == 2);
                    // sample_cnt and count_w reset when going back to B
                    sample_cnt <= 2'd0;
                    count_w <= 2'd0;
                end
                default: begin
                    // safety defaults
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
                // Wait for s=1 to start sampling
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (sample_cnt == 2'd2)
                    next_state = C; // after 3 samples go to output
                else
                    next_state = B; // keep sampling
            end
            C: begin
                // After output cycle, restart sampling immediately
                next_state = B;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

endmodule