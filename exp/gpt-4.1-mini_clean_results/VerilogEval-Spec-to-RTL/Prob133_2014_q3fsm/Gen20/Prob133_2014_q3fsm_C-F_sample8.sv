module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg [1:0] cycle_cnt;  // counts 0 to 2
    reg [1:0] w_count;    // counts number of w=1 in 3-cycle window

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    // Only reset counters on reset or entering A, avoid resetting every cycle to reduce toggling
                    if (cycle_cnt != 0 || w_count != 0) begin
                        cycle_cnt <= 2'd0;
                        w_count <= 2'd0;
                    end
                    if (s)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    if (cycle_cnt == 2) begin
                        // End of 3-cycle window: output z=1 if exactly two w=1's (w_count + w == 2)
                        z <= ((w_count + w) == 2);
                        cycle_cnt <= 2'd0;
                        w_count <= 2'd0;
                    end else begin
                        // Accumulate w and increment cycle count
                        z <= 1'b0;
                        cycle_cnt <= cycle_cnt + 2'd1;
                        w_count <= w_count + w;
                    end
                    state <= B;
                end
            endcase
        end
    end

endmodule