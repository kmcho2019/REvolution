module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: 1 bit for two states
    typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;
    state_t state, next_state;

    reg [1:0] cycle_count, next_cycle_count;
    reg [1:0] w_count, next_w_count;
    reg next_z;

    // Combinational logic for next state, counters, and output
    always @(*) begin
        // Defaults to hold current values and zero output
        next_state = state;
        next_cycle_count = cycle_count;
        next_w_count = w_count;
        next_z = 1'b0;

        case(state)
            A: begin
                // In A: counters reset, output zero, wait for s=1
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
                next_z = 1'b0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // Remain in B indefinitely
                next_state = B;

                if (cycle_count < 2) begin
                    // For cycles 0 and 1: increment cycle count,
                    // increment w_count only if w==1
                    next_cycle_count = cycle_count + 1;
                    next_w_count = w ? (w_count + 1) : w_count;
                    next_z = 1'b0; // output only after 3rd cycle
                end else begin
                    // On 3rd cycle (cycle_count == 2):
                    // output z=1 if exactly two w=1 counted (including current w)
                    // note: count w for this cycle also if w==1
                    if (w_count + (w ? 1 : 0) == 2)
                        next_z = 1'b1;
                    else
                        next_z = 1'b0;
                    // Reset counters for next 3-cycle window
                    next_cycle_count = 2'd0;
                    next_w_count = 2'd0;
                end
            end
            default: begin
                // Safety fallback to initial state and zero counts
                next_state = A;
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: register state, counters, output with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_count <= next_cycle_count;
            w_count <= next_w_count;
            z <= next_z;
        end
    end

endmodule