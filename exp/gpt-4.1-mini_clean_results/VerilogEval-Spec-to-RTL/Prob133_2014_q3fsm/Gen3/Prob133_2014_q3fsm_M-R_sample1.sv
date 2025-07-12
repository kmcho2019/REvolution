module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 2'd0;
    localparam B = 2'd1;
    localparam C = 2'd2;

    reg [1:0] state, next_state;
    reg [1:0] sample_cnt; // counts number of w samples taken (0 to 3)
    reg [1:0] count_w;    // counts number of w=1 during sampling

    // Sequential block: state, counters, output
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
                    // In A: reset counters and output
                    sample_cnt <= 2'd0;
                    count_w <= 2'd0;
                    z <= 1'b0;
                end

                B: begin
                    // In B: sample w and count the ones, increment sample count
                    count_w <= count_w + w;
                    sample_cnt <= sample_cnt + 1'b1;
                    z <= 1'b0; // output only in C
                end

                C: begin
                    // In C: output z based on stable count_w (which counted exactly 3 samples)
                    z <= (count_w == 2);
                    // Do not update counters here; will be reset when going back to B or A
                end

                default: begin
                    sample_cnt <= 2'd0;
                    count_w <= 2'd0;
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
                // After collecting 3 samples (sample_cnt==3), move to output state C
                if (sample_cnt == 2'd3)
                    next_state = C;
                else
                    next_state = B;
            end

            C: begin
                // After output, go back to sampling new window
                next_state = B;
            end

            default: next_state = A;
        endcase
    end

endmodule