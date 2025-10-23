module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding (2 states)
    typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;
    state_t state, next_state;

    reg [1:0] cycle_count, next_cycle_count;
    reg [1:0] w_count, next_w_count;
    reg next_z;

    // Combinational sum of w_count plus current w input
    wire [2:0] total_w = w_count + w;

    // Combinational logic: next_state, counters, and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cycle_count = cycle_count;
        next_w_count = w_count;
        next_z = 1'b0;

        case(state)
            A: begin
                // In reset/start state A: counters reset, output zero
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
                next_z = 1'b0;

                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B; // Remain in state B

                if (cycle_count < 2) begin
                    // Count cycles 0 and 1: increment counters
                    next_cycle_count = cycle_count + 1;
                    next_w_count = w_count + w;
                    next_z = 1'b0; // no output yet
                end else begin
                    // On 3rd cycle (cycle_count == 2): output z if exactly two w's
                    next_z = (total_w == 2) ? 1'b1 : 1'b0;

                    // Reset counters for next 3-cycle window
                    next_cycle_count = 2'd0;
                    next_w_count = 2'd0;
                end
            end
            default: begin
                // Safety fallback: reset state and counters
                next_state = A;
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: update state, counters, and output on posedge clk
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