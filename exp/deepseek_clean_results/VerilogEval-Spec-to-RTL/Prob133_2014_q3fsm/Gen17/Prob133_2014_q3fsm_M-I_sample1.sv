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

    // Phase tracking: single bit indicating if we're at start of window
    reg phase_start;
    reg [1:0] phase_counter; // Only [1] is used now

    // 3-bit shift register (only updated in state B)
    reg [2:0] w_history;

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Popcount calculation (only when phase_start=1)
    reg [1:0] popcount;
    always @(*) begin
        if (phase_start) begin
            case (w_history)
                3'b001, 3'b010, 3'b100: popcount = 2'd1;
                3'b011, 3'b101, 3'b110: popcount = 2'd2;
                3'b111: popcount = 2'd3;
                default: popcount = 2'd0;
            endcase
        end else begin
            popcount = 2'd0; // Don't care when not phase_start
        end
    end

    // Output logic
    assign z = (state == B) && phase_start && (popcount == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            phase_start <= 1'b1;
            phase_counter <= 2'b00;
            w_history <= 3'b000;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update shift register only in state B
                w_history <= {w_history[1:0], w};
                
                // Simplified phase tracking
                phase_start <= (phase_counter == 2'b10);
                phase_counter <= (phase_counter == 2'b10) ? 2'b00 : (phase_counter + 1'b1);
            end else begin
                // Reset when in state A
                phase_start <= 1'b1;
                phase_counter <= 2'b00;
                w_history <= 3'b000;
            end
        end
    end

endmodule