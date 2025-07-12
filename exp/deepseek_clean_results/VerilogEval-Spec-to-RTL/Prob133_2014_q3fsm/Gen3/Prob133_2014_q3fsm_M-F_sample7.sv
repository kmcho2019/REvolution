module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // Define states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window position counter (0-2)
    reg [1:0] pos_cnt;
    // Shift register for w values
    reg [2:0] w_buffer;
    // Evaluation flag (set when window completes)
    reg eval_flag;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            w_buffer <= 3'b0;
            eval_flag <= 1'b0;
            z <= 1'b0;
        end else begin
            // Default assignments
            z <= 1'b0;

            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        pos_cnt <= 2'b0;
                        w_buffer <= 3'b0;
                        eval_flag <= 1'b0;
                    end
                end
                B: begin
                    // Store current w in shift register
                    w_buffer <= {w_buffer[1:0], w};

                    // Update position counter (modulo 3)
                    pos_cnt <= (pos_cnt == 2'b10) ? 2'b00 : (pos_cnt + 1'b1);

                    // Set eval_flag when window completes (pos_cnt was 2)
                    eval_flag <= (pos_cnt == 2'b10);

                    // Output result from previous evaluation
                    if (eval_flag) begin
                        // Check if exactly two bits are set in w_buffer
                        case (w_buffer)
                            3'b011, 3'b101, 3'b110: z <= 1'b1;
                            default: z <= 1'b0;
                        endcase
                    end
                end
            endcase
        end
    end

endmodule