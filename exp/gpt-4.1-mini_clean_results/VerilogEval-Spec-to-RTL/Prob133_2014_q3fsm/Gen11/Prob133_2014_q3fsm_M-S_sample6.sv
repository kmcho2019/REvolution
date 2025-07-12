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
    reg [1:0] sample_cnt;   // Counts how many w samples collected (0 to 2)
    reg [2:0] w_shift_reg;  // Shift register to store last 3 w inputs

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            sample_cnt <= 2'd0;
            w_shift_reg <= 3'b000;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    sample_cnt <= 2'd0;
                    w_shift_reg <= 3'b000;
                    if (s)
                        state <= B;
                end
                B: begin
                    // Shift in current w sample
                    w_shift_reg <= {w_shift_reg[1:0], w};

                    if (sample_cnt == 2) begin
                        // Count number of ones in the 3-bit shift register plus current w
                        // Note w already shifted in, so count bits in w_shift_reg
                        // Count ones by summing bits
                        z <= (w_shift_reg[0] + w_shift_reg[1] + w_shift_reg[2] == 2) ? 1'b1 : 1'b0;
                        sample_cnt <= 2'd0;
                    end else begin
                        z <= 1'b0;
                        sample_cnt <= sample_cnt + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule