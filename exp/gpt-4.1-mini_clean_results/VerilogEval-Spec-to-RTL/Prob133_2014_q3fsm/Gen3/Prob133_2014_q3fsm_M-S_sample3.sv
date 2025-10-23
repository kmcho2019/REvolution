module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    reg [1:0] sample_idx;      // counts 0,1,2 for three samples
    reg [1:0] w_count;         // counts number of w=1 in current batch
    reg z_next;                // z to assert next cycle

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            sample_idx <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            state <= next_state;

            // Update output z from previous cycle's decision
            z <= z_next;
            z_next <= 1'b0;

            if (state == A) begin
                // Reset sampling on state A
                sample_idx <= 2'd0;
                w_count <= 2'd0;
            end else if (state == B) begin
                // Accumulate w count if w is 1
                if (w)
                    w_count <= w_count + 1'b1;

                if (sample_idx == 2) begin
                    // After third sample, decide output for next cycle
                    z_next <= (w_count + (w ? 1 : 0) == 2) ? 1'b1 : 1'b0;
                    // Reset for next batch
                    sample_idx <= 2'd0;
                    w_count <= 2'd0;
                end else begin
                    sample_idx <= sample_idx + 1'b1;
                end
            end
        end
    end

endmodule