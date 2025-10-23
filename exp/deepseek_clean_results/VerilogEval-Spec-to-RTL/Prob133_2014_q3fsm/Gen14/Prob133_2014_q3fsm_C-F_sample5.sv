module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    // Window tracking
    reg [1:0] cycle_count;
    reg [2:0] w_samples;
    wire window_complete = (cycle_count == 2'b10);

    // Next state logic (combinational)
    wire next_state = (state == STATE_A) ? (s ? STATE_B : STATE_A) : STATE_B;

    // Optimized 2-of-3 detector (LUT-style)
    wire two_ones = 
        (~w_samples[2] & w_samples[1] & w_samples[0]) |  // 011
        (w_samples[2] & ~w_samples[1] & w_samples[0]) |  // 101
        (w_samples[2] & w_samples[1] & ~w_samples[0]);    // 110

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            cycle_count <= 2'b0;
            w_samples <= 3'b0;
        end else begin
            state <= next_state;
            
            if (state == STATE_B) begin
                // Update cycle counter (modulo 3)
                cycle_count <= window_complete ? 2'b00 : (cycle_count + 1'b1);
                
                // Shift in new w value only when counter < 2 (power optimization)
                if (!window_complete) begin
                    w_samples <= {w_samples[1:0], w};
                end
            end else begin
                // Reset counters in state A
                cycle_count <= 2'b0;
                w_samples <= 3'b0;
            end
        end
    end

    // Output logic (only active when window completes)
    assign z = (state == STATE_B) && window_complete && two_ones;

endmodule