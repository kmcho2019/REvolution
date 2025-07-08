module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg {A, B} state_t;
    state_t state, next_state;

    reg [1:0] cycle_count;    // Counts 0 to 3 cycles for w sampling
    reg [1:0] w_count;        // Counts how many times w=1 in 3 cycles
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 0;
            w_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            // Output z is registered and updated here
            z <= z_next;

            if (state == A) begin
                // in A, counters cleared
                cycle_count <= 0;
                w_count <= 0;
            end else if (state == B) begin
                if (cycle_count < 3) begin
                    // Accumulate w_count on current cycle
                    cycle_count <= cycle_count + 1'b1;
                    w_count <= w_count + w;
                    z_next <= 0; // output z only after 3 cycles, so 0 meanwhile
                end else begin
                    // After 3 cycles, output z according to w_count==2
                    cycle_count <= 1; // start next 3-cycle window counting from 1 (current cycle)
                    w_count <= w;     // start new counting with current w
                    z_next <= (w_count == 2) ? 1'b1 : 1'b0;
                end
            end else begin
                // Default assignments to avoid latches
                cycle_count <= 0;
                w_count <= 0;
                z_next <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B; // always stay in B after entering
            end
            default: next_state = A;
        endcase
    end

endmodule