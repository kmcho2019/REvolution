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

    // Phase counter (0-2) to track position in 3-cycle window
    reg [1:0] phase;

    // 3-bit shift register to store last 3 w values
    reg [2:0] w_history;

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Optimized popcount calculation (balanced adder tree)
    wire [1:0] popcount;
    wire [1:0] temp_sum = w_history[0] + w_history[1];
    assign popcount = temp_sum + w_history[2];

    // Output logic - compute only when needed (phase==0)
    reg z_reg;
    assign z = z_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase <= 2'd0;
            w_history <= 3'b000;
            z_reg <= 1'b0;
        end else begin
            state <= next_state;
            z_reg <= 1'b0;  // Default value

            if (state == B) begin
                // Update shift register only in state B
                w_history <= {w_history[1:0], w};
                
                // Optimized phase comparison (check LSB for phase==0)
                if (phase == 2'd2) begin
                    phase <= 2'd0;
                    // Compute popcount and z only at window boundary
                    if (popcount == 2'd2) begin
                        z_reg <= 1'b1;
                    end
                end else begin
                    phase <= phase + 1'b1;
                end
            end else begin
                // Reset counters when in state A
                phase <= 2'd0;
                w_history <= 3'b000;
            end
        end
    end

endmodule