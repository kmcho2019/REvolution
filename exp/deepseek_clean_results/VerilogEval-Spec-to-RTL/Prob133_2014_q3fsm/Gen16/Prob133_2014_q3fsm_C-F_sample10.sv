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

    // Next state logic
    wire next_state = reset ? A : (state == A) ? (s ? B : A) : B;

    // Balanced popcount calculation
    wire [1:0] popcount = (w_history[0] + w_history[1]) + w_history[2];

    // Optimized output logic
    assign z = (state == B) && (~phase[0] & ~phase[1]) && (popcount == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
            w_history <= 3'b000;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update shift register only in state B
                w_history <= {w_history[1:0], w};
                
                // Update phase counter
                phase <= (phase == 2'd2) ? 2'd0 : phase + 1'b1;
            end else begin
                // Reset counters when not in state B
                phase <= 2'd0;
                w_history <= 3'b000;
            end
        end
    end

endmodule