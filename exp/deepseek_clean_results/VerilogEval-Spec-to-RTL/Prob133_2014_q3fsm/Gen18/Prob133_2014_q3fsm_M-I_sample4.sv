module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Shift register for w values (3 bits)
    reg [2:0] w_history;

    // Cycle counter (0-2)
    reg [1:0] cycle_count;

    // State transition logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Clock gating signals
    wire counters_enable = (state == B) && !reset;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_history <= 3'b000;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            if (counters_enable) begin
                // Update cycle counter with wrap-around
                cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1);
                
                // Shift in new w value
                w_history <= {w_history[1:0], w};
                
                // Precompute output one cycle early
                if (cycle_count == 2'd2) begin
                    z <= (w_history[1:0] + w) == 2'd2;
                end
            end else begin
                // Reset counters when in state A
                cycle_count <= 2'b00;
                w_history <= 3'b000;
                z <= 1'b0;
            end
        end
    end

endmodule