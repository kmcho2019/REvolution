module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A  = 2'b00,
        B0 = 2'b01,
        B1 = 2'b10,
        B2 = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // Count of w=1 in current 3-cycle window
    reg [1:0] count_ones;

    // Cycle counter from 0 to 2 (three cycles)
    reg [1:0] cycle_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count_ones <= 0;
            cycle_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            // Default output
            z <= 0;

            case(state)
                A: begin
                    count_ones <= 0;
                    cycle_count <= 0;
                    z <= 0;
                end
                B0, B1, B2: begin
                    // Accumulate count_ones based on w
                    if (w)
                        count_ones <= count_ones + 1;
                    else
                        count_ones <= count_ones;

                    cycle_count <= cycle_count + 1;
                    z <= 0;
                end
                default: ; // Should not occur
            endcase

            // At the end of 3 cycles (when cycle_count == 2 and we are in B2), output z in next clock
            // But since FSM has only 4 states, and B3 is not used explicitly, we handle output logic carefully below
        end
    end

    // Next state and z logic
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

    // Output z logic is delayed by one cycle after counting 3 cycles.
    // To implement this, store z in a register and assert z at the B0 state,
    // based on count_ones counted in previous 3 cycles.

    // Add a register to hold z signal computed from previous count_ones
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            z <= 0;
            z_next <= 0;
        end else begin
            // z asserted at B0 based on count_ones counted in last 3 cycles (count_ones is updated in previous cycles)
            if (state == B0) begin
                // At start of counting window, output z based on previous count_ones
                // But at first B0 after A, count_ones = 0, no output z
                // So only output z if we came from B2 (completed a 3-cycle window)
                z <= (count_ones == 2) ? 1'b1 : 1'b0;
            end else begin
                z <= 0;
            end
        end
    end

endmodule