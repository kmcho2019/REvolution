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

    // One-hot phase counter (phase0, phase1, phase2)
    reg [2:0] phase;

    // 3-bit shift register for w history (clock-gated)
    reg [2:0] w_history;
    wire w_history_en = (state == B) && ~reset;

    // Next state logic (simplified)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Optimized pattern matching for exactly two 1's
    wire exactly_two_ones = (w_history == 3'b011) || 
                          (w_history == 3'b101) || 
                          (w_history == 3'b110);

    // Output only evaluated at phase0 in state B
    assign z = (state == B) && phase[0] && exactly_two_ones;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 3'b001;  // Start at phase0
            w_history <= 3'b000;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update shift register only when enabled
                if (w_history_en) begin
                    w_history <= {w_history[1:0], w};
                end
                
                // One-hot phase counter rotation
                phase <= {phase[1:0], phase[2]};
            end else begin
                // Reset phase counter and w_history when leaving B
                phase <= 3'b001;
                if (state == B) begin
                    w_history <= 3'b000;
                end
            end
        end
    end

endmodule