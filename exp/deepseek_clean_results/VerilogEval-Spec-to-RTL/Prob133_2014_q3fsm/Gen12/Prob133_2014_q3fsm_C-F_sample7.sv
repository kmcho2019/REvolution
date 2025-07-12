module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Phase tracking (only need to detect phase=0)
    reg phase_bit;  // 0 when phase=0, 1 otherwise

    // 3-bit shift register for w history
    reg [2:0] w_history;

    // State transition
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Optimized popcount using balanced adder tree
    wire [1:0] popcount = {1'b0, w_history[0]} + {1'b0, w_history[1]} + {1'b0, w_history[2]};

    // Output logic - active at start of new window when exactly two 1s
    assign z = (state == B) && (~phase_bit) && (popcount == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase_bit <= 1'b1;  // Start at phase=0 after reset
            w_history <= 3'b000;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update shift register
                w_history <= {w_history[1:0], w};

                // Update phase tracking (cycles 0->1->2->0...)
                if (~phase_bit) 
                    phase_bit <= 1'b1;  // Was phase=0, now phase=1
                else if (w_history[1])  // Detect when we were at phase=2
                    phase_bit <= 1'b0;  // Next is phase=0
            end else begin
                // Reset counters when in state A
                phase_bit <= 1'b1;
                w_history <= 3'b000;
            end
        end
    end

endmodule