module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0,
               B = 1'b1;

    reg state;

    // cycle_cnt counts 0..3: 0..2 for sampling w, 3 for output cycle
    reg [1:0] cycle_cnt;

    // count_w counts number of w=1 in the 3-cycle window (max 3)
    reg [1:0] count_w;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            count_w <= 2'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;           // no output in A
                    cycle_cnt <= 2'd0;
                    count_w <= 2'd0;
                    if (s == 1'b1) begin
                        state <= B;
                        // start counting next cycle (cycle_cnt=0)
                        cycle_cnt <= 2'd0;
                        count_w <= 2'd0;
                    end
                end

                B: begin
                    if (cycle_cnt < 2'd3) begin
                        if (cycle_cnt < 2'd3 - 1) begin
                            // For cycle_cnt = 0,1,2: accumulate w
                            count_w <= count_w + (w ? 1'b1 : 1'b0);
                            z <= 1'b0; // no output yet
                            cycle_cnt <= cycle_cnt + 1'b1;
                        end else begin
                            // cycle_cnt == 3: output cycle, no counting w
                            // Output z=1 if count_w == 2, else 0
                            // After outputting, reset counters and start new window
                            z <= (count_w == 2) ? 1'b1 : 1'b0;
                            count_w <= 2'd0;
                            cycle_cnt <= 2'd0;
                        end
                    end else begin
                        // Defensive else: should never happen
                        cycle_cnt <= 2'd0;
                        count_w <= 2'd0;
                        z <= 1'b0;
                    end
                end

                default: begin
                    state <= A;
                    cycle_cnt <= 2'd0;
                    count_w <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule