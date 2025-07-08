module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10
    } state_t;

    state_t state, next_state;
    reg [1:0] sample_count;  // counts 0 to 2 for three samples (0,1,2)
    reg [1:0] w_count;       // counts how many w=1 in 3 samples

    // State and counters update (synchronous)
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            sample_count <= 0;
            w_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    sample_count <= 0;
                    w_count <= 0;
                    z <= 0;
                end
                B: begin
                    // sample w and update w_count
                    if (w)
                        w_count <= w_count + 1'b1;
                    else
                        w_count <= w_count;
                    sample_count <= sample_count + 1'b1;
                    z <= 0;
                end
                C: begin
                    // output z based on w_count from previous 3 samples
                    z <= (w_count == 2);
                    // reset counters for next 3 samples
                    sample_count <= 0;
                    w_count <= 0;
                end
                default: begin
                    sample_count <= 0;
                    w_count <= 0;
                    z <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (sample_count == 2)  // 3 samples taken (0,1,2)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

endmodule