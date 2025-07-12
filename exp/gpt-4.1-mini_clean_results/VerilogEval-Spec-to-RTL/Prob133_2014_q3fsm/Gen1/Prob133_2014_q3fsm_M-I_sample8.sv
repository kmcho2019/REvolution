module TopModule(
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
    reg [1:0] cycle_count; // counts 0..2 for 3 cycles window
    reg [1:0] w_count;     // counts number of w==1 in current window
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    z_next <= 1'b0;
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    if (s == 1'b1)
                        state <= B;
                    else
                        state <= A;
                end
                B: begin
                    // Default z output is previous cycle's evaluation
                    z <= z_next;

                    // Accumulate w count in current window
                    w_count <= w_count + w;

                    if (cycle_count == 2) begin
                        // End of 3rd cycle: evaluate if exactly two w=1 in these three cycles
                        // w_count already includes current cycle's w, so just check:
                        // if w_count == 2 then z_next=1 else 0
                        if ((w_count + w) == 2) // wait, we added w above, careful not to double count
                            // Above line is double counting current w, because w_count includes w
                            // fix: w_count before adding w + w, but we already added w this cycle
                            // So just check if w_count == 2 here
                            z_next <= 1'b1;
                        else
                            z_next <= 1'b0;

                        // Reset counters for next window
                        cycle_count <= 2'd0;
                        w_count <= 2'd0;
                    end else begin
                        // Increment cycle_count for next cycle
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // state remains B
                    state <= B;
                end
            endcase
        end
    end

endmodule