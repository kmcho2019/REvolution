module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        Z_OUT = 2'b10 // transient state to output z=1 next cycle (optional, but not needed if we output z in cycle after counting)
    } state_t;

    state_t state, next_state;

    reg [1:0] cycle_count; // counts 0 to 2 cycles in B
    reg [1:0] w_count;     // counts number of w=1 in current 3-cycle window
    reg z_next;

    // State and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 0;
            w_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;

            if (state == B) begin
                cycle_count <= cycle_count + 1;
                if (w)
                    w_count <= w_count + 1;
            end else begin
                cycle_count <= 0;
                w_count <= 0;
            end

            z <= z_next;
        end
    end

    // Next state logic and z_next logic
    always @(*) begin
        next_state = state;
        z_next = 0;
        case (state)
            A: begin
                z_next = 0;
                if (s)
                    next_state = B;
            end

            B: begin
                if (cycle_count == 2) begin
                    // After 3 cycles (0,1,2), evaluate w_count
                    if (w_count + (w ? 1 : 0) == 2) begin
                        // set z=1 in next cycle
                        z_next = 1;
                    end else begin
                        z_next = 0;
                    end
                    // restart counting for next 3 cycles
                    // stay in B
                    next_state = B;
                end else begin
                    z_next = 0;
                    next_state = B;
                end
            end

            default: begin
                next_state = A;
                z_next = 0;
            end
        endcase
    end

endmodule