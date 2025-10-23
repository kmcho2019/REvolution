module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, state_next;
    reg [1:0] cycle_count, cycle_count_next;
    reg [1:0] w_count, w_count_next;

    // z is registered, asserted for exactly one cycle, set in cycle after 3rd sample
    reg z_next;

    // Combinational next-state, counters, and output logic
    always @(*) begin
        // Defaults: hold current values, z off by default
        state_next = state;
        cycle_count_next = cycle_count;
        w_count_next = w_count;
        z_next = 1'b0;

        case (state)
            A: begin
                // Wait in A until s=1, then start sampling in B
                if (s) begin
                    state_next = B;
                    cycle_count_next = 2'd0;
                    w_count_next = 2'd0;
                    z_next = 1'b0;
                end else begin
                    // Remain in A, clear counters and output
                    cycle_count_next = 2'd0;
                    w_count_next = 2'd0;
                    z_next = 1'b0;
                end
            end

            B: begin
                if (cycle_count < 2) begin
                    // First two sampling cycles: accumulate w, increment cycle count
                    cycle_count_next = cycle_count + 1'b1;
                    w_count_next = w_count + w;
                    z_next = 1'b0; // no output during sampling
                end else begin
                    // On third cycle (cycle_count == 2):
                    // Accumulate current w input, then output z next cycle if exactly two ones
                    cycle_count_next = 2'd0;
                    w_count_next = 2'd0;
                    // Output pulse in the next clock cycle after this sampling cycle,
                    // so generate z here based on previous w_count + current w
                    z_next = (w_count + w == 2) ? 1'b1 : 1'b0;
                end
                state_next = B; // stay in B indefinitely
            end

            default: begin
                // Defensive default to reset state
                state_next = A;
                cycle_count_next = 2'd0;
                w_count_next = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential logic: state, counters, and output update on posedge clk with synchronous reset
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