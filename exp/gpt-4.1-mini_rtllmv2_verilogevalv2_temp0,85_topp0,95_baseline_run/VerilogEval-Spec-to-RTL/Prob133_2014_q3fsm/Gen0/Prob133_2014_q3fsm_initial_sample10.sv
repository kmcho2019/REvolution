module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A = 1'b0,
               B = 1'b1;

    reg state, next_state;

    reg [1:0] cycle_count; // counts 0 to 2 (3 cycles)
    reg [1:0] w_count;     // counts how many times w=1 in 3 cycles

    reg z_next;

    // State and counters sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            if (state == A) begin
                // In A, counters are reset
                cycle_count <= 2'd0;
                w_count <= 2'd0;
                z <= 1'b0; // output 0 in A
            end else begin
                // In B state, count cycles and w's
                if (cycle_count < 2'd2) begin
                    cycle_count <= cycle_count + 1'b1;
                    if (w)
                        w_count <= w_count + 1'b1;
                    z <= 1'b0; // during counting cycles output is 0
                end else begin
                    // Last cycle in the group
                    // On this cycle count=2, w_count will be updated for this cycle
                    if (w)
                        w_count <= w_count + 1'b1;
                    cycle_count <= 2'd0; // reset for next window
                    // Next cycle, z will be set based on w_count + current w
                    // But to have z valid immediately next cycle, do combinational below
                    z <= (w_count + w == 2) ? 1'b1 : 1'b0;
                    w_count <= 2'd0; // reset w_count after evaluating output
                end
            end
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
                next_state = B; // Always stay in B once entered
            end
            default: next_state = A;
        endcase
    end

endmodule