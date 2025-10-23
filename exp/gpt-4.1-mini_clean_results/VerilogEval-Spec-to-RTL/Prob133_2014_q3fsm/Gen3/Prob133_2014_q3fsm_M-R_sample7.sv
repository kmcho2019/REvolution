module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;
    state_t state, next_state;

    reg [1:0] cycle_count, next_cycle_count;
    reg [1:0] w_count, next_w_count;
    reg next_z;

    // Sequential state and registers update
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

    // Combinational next state, counters, and output logic
    always @(*) begin
        // Defaults to current values
        next_state = state;
        next_cycle_count = cycle_count;
        next_w_count = w_count;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0;  // z=0 in A
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B; // stay in B forever

                if (cycle_count < 2) begin
                    // accumulate w counts for first two cycles
                    next_cycle_count = cycle_count + 1;
                    next_w_count = w_count + w;
                    next_z = 1'b0; // output only after 3 cycles counted
                end else begin
                    // third cycle counted now (cycle_count == 2)
                    // evaluate z for exactly two w=1 in 3 cycles
                    next_z = ((w_count + w) == 2) ? 1'b1 : 1'b0;

                    // reset counters for next 3-cycle group
                    next_cycle_count = 2'd0;
                    next_w_count = 2'd0;
                end
            end
            default: begin
                // safety fallback
                next_state = A;
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

endmodule