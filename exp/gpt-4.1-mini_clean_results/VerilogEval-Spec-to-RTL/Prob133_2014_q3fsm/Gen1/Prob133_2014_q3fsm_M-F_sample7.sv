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
    reg [1:0] cycle_count; // counts 0 to 2 for 3 cycles
    reg [1:0] w_count;     // counts how many times w=1 in current 3-cycle window

    // We'll register z as output. z should be asserted one cycle after the counting window.
    // So we need to store the z value for the next cycle after counting completes.
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            case(state)
                A: begin
                    // Output zero in A
                    z <= 1'b0;
                    z_next <= 1'b0;
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    if (s == 1'b1) begin
                        state <= B;
                        // Start counting window from cycle 0 on entering B
                        cycle_count <= 2'd0;
                        w_count <= 2'd0;
                    end else begin
                        state <= A;
                    end
                end

                B: begin
                    // Update output from previous counting window
                    z <= z_next;

                    if (cycle_count < 2) begin
                        // Counting cycles 0 and 1: accumulate w and increment cycle_count
                        w_count <= w_count + w;
                        cycle_count <= cycle_count + 1;
                        // z_next stays as is because output will be updated after 3rd cycle
                    end else if (cycle_count == 2) begin
                        // Third cycle: accumulate w and prepare z_next based on total count
                        w_count <= 0; // reset for next window starting next cycle
                        cycle_count <= 0; // reset counter for next window
                        // w_count now contains count from first two cycles, add current w:
                        // total_ones = w_count + w
                        // z_next is set to 1 if total_ones == 2, else 0
                        z_next <= ((w_count + w) == 2) ? 1'b1 : 1'b0;
                    end
                end

                default: begin
                    // Should not happen, reset state
                    state <= A;
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    z <= 1'b0;
                    z_next <= 1'b0;
                end
            endcase
        end
    end

endmodule