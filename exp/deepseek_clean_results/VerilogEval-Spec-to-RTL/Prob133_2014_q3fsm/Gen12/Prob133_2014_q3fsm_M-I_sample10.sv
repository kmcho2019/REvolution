module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Tracking registers (optimized)
    reg counter;  // Only need 1 bit (0-1-2 cycle)
    reg [1:0] ones_count;  // Count of 1s in current window

    // State transition logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Window evaluation signals (optimized)
    wire window_complete = counter;  // True when counter == 1 (after 2 cycles)
    wire evaluate = (state == B) && (counter == 1'b0);
    wire [1:0] new_ones = ones_count + w;

    // Output assignment
    assign z = evaluate && (ones_count == 2'd2);

    // Sequential logic (optimized)
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counter <= 1'b0;
            ones_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update counter mod 3 (0->1->2->0)
                counter <= window_complete ? 1'b0 : ~counter;

                // Update ones count only when needed
                if (!window_complete) begin
                    ones_count <= new_ones;
                end else begin
                    ones_count <= w;  // Reset for new window
                end
            end else begin
                // Reset tracking in state A
                counter <= 1'b0;
                ones_count <= 2'd0;
            end
        end
    end

endmodule