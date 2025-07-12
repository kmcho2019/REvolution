module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding (2 bits)
    localparam [1:0]
        A  = 2'b00, // Wait for s=1
        B0 = 2'b01, // First sample cycle in B
        B1 = 2'b10, // Second sample cycle in B
        B2 = 2'b11; // Third sample cycle in B

    reg [1:0] state, next_state;
    reg [1:0] w_count, next_w_count;

    // Combinational logic for next state and next w_count
    always @(*) begin
        // Default assignments
        next_state = state;
        next_w_count = w_count;

        case (state)
            A: begin
                if (s)
                    next_state = B0;
                else
                    next_state = A;
                next_w_count = 2'd0;
            end

            B0: begin
                next_state = B1;
                next_w_count = w ? 2'd1 : 2'd0;
            end

            B1: begin
                next_state = B2;
                next_w_count = w_count + (w ? 2'd1 : 2'd0);
            end

            B2: begin
                next_state = B0;
                // w_count is reset after evaluating output z
                next_w_count = 2'd0;
            end

            default: begin
                next_state = A;
                next_w_count = 2'd0;
            end
        endcase
    end

    // Synchronous process for state, w_count and output z
    always @(posedge clk) begin
        if (reset) begin
            state   <= A;
            w_count <= 2'd0;
            z       <= 1'b0;
        end else begin
            state   <= next_state;
            w_count <= next_w_count;

            // Output logic: z asserted only after third w sample (state B2)
            if (state == B2) begin
                // total count is w_count (from previous 2 samples) plus current w
                // But note that w_count was reset to 0 in B2 last cycle, so here w_count represents previous two counts,
                // and w for this clock cycle is new input. However, we sample z based on previous w_count + current w from last cycle.

                // Since w_count is updated on posedge, it currently holds the count for samples before current clock
                // So output should be based on w_count + w at previous cycle, which is reflected in next_w_count at B2.
                // But since output z is synchronous and must reflect the count of exactly three samples,
                // and next_w_count is reset to zero, the correct total count is the w_count plus the current w input from the previous cycle.

                // To fix this, output z is asserted using next_w_count computed combinationally, which includes the current w sample,
                // so we compute sum here with w included.

                // However, since we update w_count at posedge, the w_count already reflects two previous counts,
                // and w at current clock is not included yet. So we must compute total count as w_count + w (input at current clock).

                // But since synchronous output z updates at the same clock edge, w input at that clock is considered current input.

                // We thus compute total_count here as w_count + w input sampled at posedge clk.

                if ((w_count + (w ? 2'd1 : 2'd0)) == 2)
                    z <= 1'b1;
                else
                    z <= 1'b0;
            end else begin
                z <= 1'b0;
            end
        end
    end

endmodule