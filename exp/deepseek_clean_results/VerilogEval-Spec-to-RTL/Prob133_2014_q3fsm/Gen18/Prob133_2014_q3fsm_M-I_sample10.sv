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

    // Phase counter (0-2)
    reg [1:0] phase;

    // 3-bit shift register for w history
    reg [2:0] w_history;

    // Registered popcount result
    reg [1:0] popcount_reg;

    // Next state logic
    wire next_state = reset ? A : (state == A) ? (s ? B : A) : B;

    // Phase comparison (simplified)
    wire phase_zero = (phase == 2'd0);

    // Balanced popcount calculation (only when phase == 0)
    wire [1:0] popcount = phase_zero ? 
                         ((w_history[0] + w_history[1]) + w_history[2]) : 
                         2'b00;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
            w_history <= 3'b000;
            popcount_reg <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update shift register only in state B
                w_history <= {w_history[1:0], w};
                
                // Update phase counter
                phase <= (phase == 2'd2) ? 2'd0 : phase + 1'b1;

                // Register popcount result when phase == 0
                if (phase_zero) begin
                    popcount_reg <= popcount;
                end

                // Output logic (registered)
                z <= phase_zero && (popcount_reg == 2'd2);
            end else begin
                // Reset counters when not in state B
                phase <= 2'd0;
                w_history <= 3'b000;
                popcount_reg <= 2'b00;
                z <= 1'b0;
            end
        end
    end

endmodule