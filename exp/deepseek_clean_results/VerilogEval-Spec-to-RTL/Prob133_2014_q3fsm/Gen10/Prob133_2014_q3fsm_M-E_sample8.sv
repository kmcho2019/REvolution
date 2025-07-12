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

    // Smart counter (counts w=1 occurrences in current window)
    reg [1:0] w_counter;
    reg [1:0] cycle_counter;  // Tracks position in 3-cycle window

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_counter <= 2'b00;
            cycle_counter <= 2'b00;
            z <= 1'b0;
        end else begin
            // State transition
            state <= next_state;

            // In state B: update counters and evaluate condition
            if (state == B) begin
                // Update counters
                cycle_counter <= (cycle_counter == 2'd2) ? 2'd0 : (cycle_counter + 1'b1);
                w_counter <= (cycle_counter == 2'd2) ? {1'b0, w} : (w_counter + w);

                // Evaluate condition at end of window
                if (cycle_counter == 2'd2) begin
                    z <= (w_counter + w) == 2'd2;  // Total of 2 ones in window
                end
            end else begin
                // Reset counters when leaving state B
                w_counter <= 2'b00;
                cycle_counter <= 2'b00;
                z <= 1'b0;
            end
        end
    end

endmodule