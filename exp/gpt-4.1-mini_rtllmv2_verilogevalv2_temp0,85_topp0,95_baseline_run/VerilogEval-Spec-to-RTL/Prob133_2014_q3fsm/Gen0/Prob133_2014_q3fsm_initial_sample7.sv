module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;
    state_t state, next_state;

    reg [1:0] w_count;      // counts how many w=1 samples in the 3-cycle window
    reg [1:0] cycle_count;  // counts from 0 to 2 cycles (3 samples)
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 0;
            cycle_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            z <= z_next;

            if (state == B) begin
                // Sample w for 3 cycles
                w_count <= w_count + w;
                cycle_count <= cycle_count + 1'b1;
            end else begin
                // In state A, clear counters
                w_count <= 0;
                cycle_count <= 0;
            end
        end
    end

    // Next state and z_next logic
    always @(*) begin
        next_state = state;
        z_next = 0; // default output

        case(state)
            A: begin
                if (s == 1)
                    next_state = B;
                z_next = 0;
            end
            B: begin
                // When cycle_count == 2, after sampling w for 3 cycles (0,1,2)
                if (cycle_count == 2) begin
                    // Decide output z in the *next* cycle, so z_next gets value of previous count after this cycle
                    // But z is updated at posedge, so output z must be delayed by one cycle.
                    // So here, set z_next based on w_count + current w (last sample)
                    int total_w = w_count + w;
                    if (total_w == 2)
                        z_next = 1;
                    else
                        z_next = 0;

                    // After output, reset counters for next 3 cycles
                    // But counters update on posedge, here just keep next_state = B
                    // counters reset by sequential block on next cycle if state remains B and cycle_count resets there
                end else begin
                    z_next = 0;
                end
            end
            default: begin
                next_state = A;
                z_next = 0;
            end
        endcase
    end

    // Reset cycle_count and w_count after 3 samples (cycle_count == 2 means next is 3 samples done)
    always @(posedge clk) begin
        if (!reset && state == B && cycle_count == 2)
            cycle_count <= 0;
            w_count <= 0;
    end

endmodule