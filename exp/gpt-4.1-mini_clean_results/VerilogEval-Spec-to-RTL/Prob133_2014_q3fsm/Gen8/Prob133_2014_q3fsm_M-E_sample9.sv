module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 2'd0;  // Waiting for s=1
    localparam B = 2'd1;  // Counting w over 3 cycles
    localparam C = 2'd2;  // Output z based on count

    reg [1:0] state, next_state;
    reg [1:0] cycle_count, next_cycle_count;   // Counts 0..2 cycles in B
    reg [1:0] w_count, next_w_count;            // Counts number of w=1 inputs in window

    always @(*) begin
        // Default next-state assignments
        next_state = state;
        next_cycle_count = cycle_count;
        next_w_count = w_count;
        z = 1'b0; // default output

        case (state)
            A: begin
                // Wait for s=1 to start counting window
                if (s)
                    next_state = B;
                else
                    next_state = A;
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
            end

            B: begin
                // Count w=1 inputs over 3 cycles
                next_w_count = w_count + w;
                if (cycle_count == 2) begin
                    // Completed 3 cycles, go to output state
                    next_state = C;
                end else begin
                    // Continue counting
                    next_cycle_count = cycle_count + 1;
                    next_state = B;
                end
                z = 1'b0; // output zero during counting
            end

            C: begin
                // Output z based on count
                if (w_count == 2)
                    z = 1'b1;
                else
                    z = 1'b0;
                // After output, reset counters and return to B
                next_state = B;
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
            end

            default: begin
                // Safety fallback to state A
                next_state = A;
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
                z = 1'b0;
            end
        endcase
    end

    // Sequential logic: state, counters, and output
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
            z <= z;  // z is combinationally assigned above, so this just holds value until next cycle
        end
    end

endmodule