module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding: 2 bits for 4 states
    localparam A   = 2'd0; // Waiting for s=1
    localparam B_0 = 2'd1; // 1st cycle in counting window
    localparam B_1 = 2'd2; // 2nd cycle in counting window
    localparam B_2 = 2'd3; // 3rd cycle in counting window

    reg [1:0] state, next_state;
    reg [1:0] w_count;   // counts how many times w=1 in the 3-cycle window
    reg [1:0] final_count; // holds total count after 3 cycles for output decision

    // Next state logic combinational block
    always @(*) begin
        case(state)
            A:   next_state = s ? B_0 : A;
            B_0: next_state = B_1;
            B_1: next_state = B_2;
            B_2: next_state = B_0;
            default: next_state = A;
        endcase
    end

    // Sequential logic for state, counters and output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            final_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    w_count <= 2'd0;
                    final_count <= 2'd0;
                    z <= 1'b0;
                end

                B_0, B_1: begin
                    // Increment w_count by 1 only if w==1 (gated counting to reduce toggling)
                    w_count <= w_count + (w ? 2'd1 : 2'd0);
                    z <= 1'b0;
                end

                B_2: begin
                    // Add w for 3rd cycle and latch final count to final_count for next state's output
                    final_count <= w_count + (w ? 2'd1 : 2'd0);
                    w_count <= 2'd0;  // reset count for next window
                    z <= 1'b0;        // output z is delayed one cycle, set in next state
                end

                default: begin
                    w_count <= 2'd0;
                    final_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase

            // Output z is asserted in B_0 state, using final_count latched from previous cycle
            if (state == B_2) begin
                // do nothing here, z=0 already set
            end else if (state == B_0) begin
                // Output z = 1 if exactly two w=1's counted in previous 3-cycle window
                z <= (final_count == 2);
            end else begin
                z <= 1'b0; // all other states z=0
            end
        end
    end

endmodule