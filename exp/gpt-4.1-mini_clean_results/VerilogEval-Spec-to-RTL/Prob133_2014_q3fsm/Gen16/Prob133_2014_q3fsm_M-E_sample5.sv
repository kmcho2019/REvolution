module TopModule (
    input wire clk,
    input wire reset,
    input wire s,
    input wire w,
    output reg z
);
    // State encoding: 0 = A, 1 = B
    reg state;

    // Counters: cycle counts 0..2, w_count counts number of w=1 in current 3 cycles
    reg [1:0] cycle_cnt;
    reg [1:0] w_count;

    // Flag to indicate that at end of 3-cycle window, next cycle z=1 if w_count==2
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;       // state A
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            z <= z_next;  // Output updated one cycle after counting window

            if (state == 1'b0) begin
                // State A: wait for s=1 to move to B
                z_next <= 1'b0;
                cycle_cnt <= 2'd0;
                w_count <= 2'd0;
                if (s == 1'b1)
                    state <= 1'b1; // move to B
            end else begin
                // State B: count w occurrences over 3 cycles
                // Update counters
                if (cycle_cnt < 2) begin
                    cycle_cnt <= cycle_cnt + 1;
                    w_count <= w_count + w;
                    z_next <= 1'b0;
                end else begin
                    // 3rd cycle complete, check w_count + current w
                    if ((w_count + w) == 2)
                        z_next <= 1'b1;
                    else
                        z_next <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_count <= 2'd0;
                end
            end
        end
    end

endmodule