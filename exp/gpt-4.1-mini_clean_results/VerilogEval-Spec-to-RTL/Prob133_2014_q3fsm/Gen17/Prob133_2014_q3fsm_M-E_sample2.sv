module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        A  = 2'd0,  // Wait for s=1
        B0 = 2'd1,  // 1st sampling cycle in B
        B1 = 2'd2,  // 2nd sampling cycle in B
        B2 = 2'd3   // 3rd sampling cycle in B, then output z next cycle
    } state_t;

    state_t state, next_state;

    reg [1:0] w_count, next_w_count; // Count of w=1 in current window

    always @(*) begin
        // Defaults
        next_state = state;
        next_w_count = w_count;
        z = 1'b0;  // Default output zero

        case(state)
            A: begin
                // In reset/wait state, output zero, wait for s=1
                if (s) begin
                    next_state = B0;
                    next_w_count = (w) ? 2'd1 : 2'd0; // Start counting first sample
                end else begin
                    next_state = A;
                    next_w_count = 2'd0;
                end
            end
            B0: begin
                // Second sample cycle
                next_state = B1;
                // Accumulate w count
                next_w_count = w_count + (w ? 2'd1 : 2'd0);
            end
            B1: begin
                // Third sample cycle
                next_state = B2;
                // Accumulate w count
                next_w_count = w_count + (w ? 2'd1 : 2'd0);
            end
            B2: begin
                // Output cycle: z=1 if w_count == 2
                // (w_count now contains count of 3 w samples)
                z = (w_count == 2);
                next_state = B0;
                next_w_count = 2'd0;
                // On next cycle, sampling new window starting at B0
            end
            default: begin
                next_state = A;
                next_w_count = 2'd0;
                z = 1'b0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            // z assigned combinationally in always @(*) to appear in same cycle as state
            // So register output z here to meet output port reg requirement
            z <= z;
        end
    end

endmodule