module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    reg state;          // 0 = A (wait s), 1 = B (sampling)
    reg [1:0] cnt;      // counts from 0 to 2 for the 3 cycles in B
    reg [1:0] w_count;  // count of w=1 in current 3-cycle window
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state   <= 1'b0;  // state A
            cnt     <= 2'd0;
            w_count <= 2'd0;
            z       <= 1'b0;
        end else begin
            z <= z_next;

            if (state == 1'b0) begin
                // In state A: wait for s=1 to move to state B
                if (s) begin
                    state   <= 1'b1;
                    cnt     <= 2'd0;
                    w_count <= w ? 2'd1 : 2'd0;
                end
            end else begin
                // In state B: sample w for 3 cycles
                cnt <= cnt + 1'b1;
                w_count <= w_count + w;

                if (cnt == 2'd2) begin
                    // After 3rd cycle, decide z and restart counting
                    state <= 1'b1; // remain in state B
                    cnt   <= 2'd0;
                    w_count <= 2'd0;
                end
            end
        end
    end

    // Combinational logic for z_next
    always @(*) begin
        z_next = 1'b0;
        if (state == 1'b1 && cnt == 2'd2) begin
            // On last cycle of the window, after incrementing w_count in sequential logic,
            // the w_count register still holds the count of first two cycles,
            // plus current w counted in sequential logic. So to reflect total count:
            // We must consider w counted in sequential logic after posedge clk,
            // so here w_count holds count before current cycle's w counted.
            // However, z asserted next cycle after this, so z_next only asserted here.
            // Since w_count is updated in sequential block after posedge clk,
            // here w_count still holds count for previous two cycles, and w is current input.
            // We must add w input here to get total count.
            if ( (w_count + w) == 2 )
                z_next = 1'b1;
        end
    end

endmodule