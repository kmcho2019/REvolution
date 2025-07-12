module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    reg [1:0] cycle_count;    // Counts 0,1,2 cycles within state B
    reg [1:0] w_count;        // Counts how many times w=1 in current group of 3

    reg z_next;

    // Next state logic and outputs (combinational)
    always @(*) begin
        next_state = state;
        z_next = 1'b0;

        case(state)
            A: begin
                if (s)
                    next_state = B;
            end
            B: begin
                if (cycle_count == 2) begin
                    // After 3rd cycle (cycles 0,1,2), output depends on w_count + current w
                    // But since w_count and cycle_count are updated sequentially, z_next is assigned in sequential block
                    // Next state remains B to continue checking next groups
                    next_state = B;
                end
            end
            default: next_state = A;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            if (state == A) begin
                // Waiting for s=1; reset counters and output
                cycle_count <= 2'd0;
                w_count <= 2'd0;
                z <= 1'b0;
            end else if (state == B) begin
                // In B, accumulate w_count over 3 cycles (cycle_count=0..2)
                if (cycle_count < 2) begin
                    // For cycles 0 and 1: accumulate w_count and increment cycle_count
                    w_count <= w_count + (w ? 1'b1 : 1'b0);
                    cycle_count <= cycle_count + 1'b1;
                    z <= 1'b0;  // output zero during counting cycles
                end else begin
                    // cycle_count==2: last cycle in group
                    // Add w of current cycle to w_count
                    // Then decide z based on total w_count
                    // Reset counters for next group
                    // Output z=1 if total count == 2, else 0
                    reg [1:0] total_count;
                    total_count = w_count + (w ? 1'b1 : 1'b0);

                    z <= (total_count == 2) ? 1'b1 : 1'b0;

                    w_count <= 2'd0;
                    cycle_count <= 2'd0;
                end
            end else begin
                // Should never get here, but safe reset
                cycle_count <= 2'd0;
                w_count <= 2'd0;
                z <= 1'b0;
            end
        end
    end

endmodule