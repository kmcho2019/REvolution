module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A  = 2'd0; // waiting for s=1
    localparam B0 = 2'd1; // 1st w sample cycle
    localparam B1 = 2'd2; // 2nd w sample cycle
    localparam B2 = 2'd3; // 3rd w sample cycle

    reg [1:0] state, next_state;
    reg [1:0] count;      // counts number of w=1 in current group (0..3)
    reg       z_next;     // output value to be asserted in the current cycle

    // Sequential logic: state, count, and z update
    always @(posedge clk) begin
        if (reset) begin
            state  <= A;
            count  <= 0;
            z      <= 0;
            z_next <= 0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    // When in A, stay if s=0 or move to B0 if s=1
                    count  <= 0;
                    z      <= 0;
                    z_next <= 0;
                end

                B0: begin
                    // At start of new group:
                    // Output stored z_next (result of previous group)
                    z <= z_next;
                    // Reset count and accumulate current w
                    count <= (w ? 1 : 0);
                    // Clear z_next to prepare for next group's result
                    z_next <= 0;
                end

                B1: begin
                    // Accumulate count of w=1
                    count <= count + (w ? 1 : 0);
                    // Keep output low during sampling
                    z <= 0;
                    // z_next unchanged until after third sample
                end

                B2: begin
                    // Accumulate count of w=1
                    count <= count + (w ? 1 : 0);
                    // Keep output low during sampling
                    z <= 0;
                    // After this cycle, determine if exactly two w=1s in group
                    // Store result in z_next for assertion next cycle
                    z_next <= (count + (w ? 1 : 0) == 2) ? 1'b1 : 1'b0;
                end

                default: begin
                    state <= A;
                    count <= 0;
                    z     <= 0;
                    z_next <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A:  next_state = (s == 1'b1) ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule