module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t state, next_state;

    // Counters for cycles and number of times w=1 seen
    reg [1:0] cycle_count;  // counts 0..2 (3 cycles)
    reg [1:0] w_count;      // counts number of times w=1 in three cycles

    // z delayed by one cycle after counting 3 cycles of w
    reg z_next;

    // State transition and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 0;
            w_count <= 0;
            z <= 0;
            z_next <= 0;
        end else begin
            state <= next_state;

            if (state == A) begin
                // In state A, just wait for s=1
                cycle_count <= 0;
                w_count <= 0;
                z <= 0;
                z_next <= 0;
            end else if (state == B) begin
                if (cycle_count < 2) begin
                    // Accumulate count of w=1
                    w_count <= w_count + w;
                    cycle_count <= cycle_count + 1;
                    z <= z_next; // output previous z_next
                end else begin
                    // Last cycle (third cycle), count w and determine z
                    // w_count already counts previous cycles, add w for current cycle:
                    reg [1:0] total_w;
                    total_w = w_count + w;
                    z_next <= (total_w == 2) ? 1'b1 : 1'b0;
                    // reset counters for next 3-cycle period
                    w_count <= 0;
                    cycle_count <= 0;
                    z <= z_next;  // output previous cycle's result
                end
            end else begin
                // Should never reach here
                cycle_count <= 0;
                w_count <= 0;
                z <= 0;
                z_next <= 0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            A: begin
                if (s == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B; // stays in B forever once entered
            end
            default: next_state = A;
        endcase
    end

endmodule