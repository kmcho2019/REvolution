module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // FSM states
    typedef enum logic [0:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t state, next_state;

    // Counter for the three w samples (0 to 3)
    reg [1:0] w_count;
    // Number of w=1 samples counted in current group
    reg [1:0] w_ones_count;
    // Register to hold output z delayed by one cycle after counting
    reg z_next;

    // Sequential logic for state, counter, accumulator, and output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            w_ones_count <= 2'd0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            state <= next_state;

            if (state == A) begin
                // In state A, no counting, reset counters and output
                w_count <= 2'd0;
                w_ones_count <= 2'd0;
                z <= 1'b0;
                z_next <= 1'b0;
            end else if (state == B) begin
                if (w_count < 2'd3) begin
                    // Accumulate w_count and w_ones_count
                    w_count <= w_count + 2'd1;
                    w_ones_count <= w_ones_count + w;
                    z <= z_next; // Output z from previous counting group (one cycle delay)
                    z_next <= 1'b0;
                end else begin
                    // After counting 3 cycles, output z_next based on w_ones_count
                    // z will be set in next cycle to z_next
                    z <= z_next;
                    // Decide z_next for next cycle:
                    // If exactly 2 ones in the last 3 samples, z_next=1 else 0
                    z_next <= (w_ones_count == 2) ? 1'b1 : 1'b0;
                    // Reset counters for next group counting
                    w_count <= 2'd1; // start counting new group, current cycle counts as first sample
                    w_ones_count <= w; // count current w as first sample of next group
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

endmodule