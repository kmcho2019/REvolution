module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    reg state;             // 0: A, 1: B
    reg [1:0] cycle_cnt;   // counts 0..2 for 3 cycles
    reg [1:0] w_accum;     // counts w=1 occurrences in window
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;        // State A
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            z <= z_next;

            if (state == 1'b0) begin
                // State A: wait for s=1
                z_next <= 1'b0;
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
                if (s)
                    state <= 1'b1;
            end else begin
                // State B: count w for 3 cycles
                if (cycle_cnt < 2) begin
                    cycle_cnt <= cycle_cnt + 1;
                    w_accum <= w_accum + w;
                    z_next <= 1'b0;
                end else begin
                    // 3rd cycle
                    // total w count in window = w_accum + w
                    z_next <= ((w_accum + w) == 2);
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                end
            end
        end
    end

endmodule