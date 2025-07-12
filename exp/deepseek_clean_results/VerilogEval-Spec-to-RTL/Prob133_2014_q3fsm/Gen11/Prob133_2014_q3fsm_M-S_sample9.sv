module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Window tracking and implicit state
    reg [1:0] pos_cnt;  // 0-2 counter for 3-cycle window
    reg [1:0] w_count;  // Count of 1's in current window

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            pos_cnt <= 2'b0;
            w_count <= 2'b0;
        end else begin
            if (pos_cnt == 0) begin
                // In state A when pos_cnt==0 and s==0
                if (s) begin
                    pos_cnt <= 2'b1;  // Move to state B
                    w_count <= w;     // Start counting
                end
            end else begin
                // In state B - counting window
                if (pos_cnt == 2'b10) begin
                    pos_cnt <= 2'b0;  // Window complete
                end else begin
                    pos_cnt <= pos_cnt + 1'b1;
                end
                w_count <= w_count + w;  // Accumulate w counts
            end
        end
    end

    // Output logic - assert when window completes (pos_cnt wraps to 0)
    assign z = (pos_cnt == 2'b0) && (w_count == 2'd2);

endmodule