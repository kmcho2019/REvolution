module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam [0:0] 
        A = 1'b0,
        B = 1'b1;

    reg state, next_state;

    // Counter for cycles inside state B: 0..2
    reg [1:0] cycle_count, next_cycle_count;

    // Count of w=1 in current 3-cycle window
    reg [1:0] w_count, next_w_count;

    // Flag to indicate output z in this cycle
    reg z_next;

    // Combinational logic for next states and outputs
    always @(*) begin
        next_state = state;
        next_cycle_count = cycle_count;
        next_w_count = w_count;
        z_next = 1'b0;

        case(state)
            A: begin
                if (s) begin
                    next_state = B;
                    next_cycle_count = 2'd0;
                    next_w_count = (w == 1'b1) ? 2'd1 : 2'd0;
                end else begin
                    next_state = A;
                    next_cycle_count = 2'd0;
                    next_w_count = 2'd0;
                end
            end

            B: begin
                if (cycle_count < 2) begin
                    // Still counting the 3-cycle window
                    next_cycle_count = cycle_count + 1'b1;
                    // Accumulate w count if w==1
                    next_w_count = w_count + (w ? 1'b1 : 1'b0);
                end else begin
                    // Last cycle of 3-cycle window
                    // Accumulate w for this cycle
                    next_w_count = w_count + (w ? 1'b1 : 1'b0);
                    // Output z if w_count (including this cycle) == 2
                    if ( (w_count + (w ? 1'b1 : 1'b0)) == 2 )
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;

                    // Restart cycle_count and w_count for next window
                    next_cycle_count = 2'd0;
                    next_w_count = 2'd0;
                end
            end

            default: begin
                next_state = A;
                next_cycle_count = 2'd0;
                next_w_count = 2'd0;
            end
        endcase
    end

    // Sequential block for state, counters and output
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
            z <= z_next;
        end
    end

endmodule