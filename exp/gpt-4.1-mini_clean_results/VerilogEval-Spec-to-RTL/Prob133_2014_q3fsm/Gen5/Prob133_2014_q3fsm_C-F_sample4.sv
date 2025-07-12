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

    reg state, state_next;

    // cycle_count counts 0,1,2 then wraps to 0 - mod-3 counter
    reg [1:0] cycle_count, cycle_count_next;

    // w_count counts how many times w=1 in current 3-cycle window (max 3 -> 2 bits enough)
    reg [1:0] w_count, w_count_next;

    // Combinational: total_w calculated as w_count + w (w treated as 0 or 1)
    wire [2:0] total_w = w_count + w;

    // Combinational logic for next state, counters, and output pulse
    reg z_next;

    always @(*) begin
        // Defaults to hold current values / no output pulse
        state_next = state;
        cycle_count_next = cycle_count;
        w_count_next = w_count;
        z_next = 1'b0;

        case (state)
            A: begin
                // Remain in A if s=0, else move to B
                if (s)
                    state_next = B;
                else
                    state_next = A;

                // In state A, counters and output remain zeroed to avoid toggling
                cycle_count_next = 2'd0;
                w_count_next = 2'd0;
                z_next = 1'b0;
            end

            B: begin
                // State B: count cycles mod 3 (0,1,2) and count w=1 in 3 cycles
                if (cycle_count < 2) begin
                    // Counting cycles 0 and 1:
                    cycle_count_next = cycle_count + 1'b1;

                    // Increment w_count only if w=1 to reduce switching
                    if (w)
                        w_count_next = w_count + 1'b1;
                    else
                        w_count_next = w_count;

                    z_next = 1'b0; // no pulse output during counting cycles
                end else begin
                    // On 3rd cycle (count=2), decide output z based on total w count
                    cycle_count_next = 2'd0; // wrap around

                    // Add current w to w_count to get total_w
                    // Reset w_count next cycle for next 3-cycle window
                    w_count_next = 2'd0;

                    // Output pulse z only if total_w == 2
                    if (total_w == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;
                end

                // Remain in state B indefinitely
                state_next = B;
            end

            default: begin
                // Should not happen, but safely reset to A
                state_next = A;
                cycle_count_next = 2'd0;
                w_count_next = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential update on positive clock edge, synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= state_next;
            cycle_count <= cycle_count_next;
            w_count <= w_count_next;
            z <= z_next;
        end
    end

endmodule