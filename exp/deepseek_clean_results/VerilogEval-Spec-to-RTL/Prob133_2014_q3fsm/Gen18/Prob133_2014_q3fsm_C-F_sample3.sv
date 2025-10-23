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

    // Phase counter (0-2)
    reg [1:0] phase;

    // 3-bit shift register for w history
    reg [2:0] w_history;

    // Balanced popcount calculation
    wire [1:0] popcount = (w_history[0] + w_history[1]) + w_history[2];

    // Output logic - active when in B state and phase wraps around
    assign z = (state == B) && (phase == 2'd0) && (popcount == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
            w_history <= 3'b0;
        end else begin
            // State transition
            state <= (state == A) ? (s ? B : A) : B;

            if (state == B) begin
                // Update w history only in state B
                w_history <= {w_history[1:0], w};
                
                // Update phase counter (0-1-2-0...)
                phase <= (phase == 2'd2) ? 2'd0 : phase + 1'b1;
            end else begin
                // Reset counters when in state A
                phase <= 2'd0;
                w_history <= 3'b0;
            end
        end
    end

endmodule