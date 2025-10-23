module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: two states only
    localparam A = 1'b0; // Waiting for s=1
    localparam B = 1'b1; // Sampling w for 3 cycles

    reg state;
    reg [1:0] cycle_count;     // Count cycles 0,1,2 for sampling 3 cycles
    reg [2:0] w_ones_count;    // Accumulate count of w=1 over 3 cycles (0 to 3)
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state        <= A;
            cycle_count  <= 2'd0;
            w_ones_count <= 3'd0;
            z            <= 1'b0;
            z_next       <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    z_next <= 1'b0;
                    if (s) begin
                        state <= B;
                        cycle_count <= 2'd0;
                        w_ones_count <= w ? 3'd1 : 3'd0; // start counting w at first cycle in B
                    end else begin
                        state <= A;
                        cycle_count <= 2'd0;
                        w_ones_count <= 3'd0;
                    end
                end

                B: begin
                    if (cycle_count == 2) begin
                        // On the third sampling cycle, evaluate output next cycle
                        z <= z_next;
                        z_next <= (w_ones_count == 3'd2) ? 1'b1 : 1'b0;
                        // Reset counters for next group of 3 cycles
                        cycle_count <= 2'd0;
                        w_ones_count <= w ? 3'd1 : 3'd0; // count current w for next cycle group
                    end else begin
                        // Continue sampling
                        cycle_count <= cycle_count + 1;
                        w_ones_count <= w_ones_count + (w ? 3'd1 : 3'd0);
                        z <= z_next;
                        z_next <= 1'b0; // no new output until 3 cycles complete
                    end
                end

                default: begin
                    state        <= A;
                    cycle_count  <= 2'd0;
                    w_ones_count <= 3'd0;
                    z            <= 1'b0;
                    z_next       <= 1'b0;
                end
            endcase
        end
    end

endmodule