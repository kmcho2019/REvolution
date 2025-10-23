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

    // Window tracking
    reg [1:0] cycle_count;  // Modulo-3 counter (0-2)
    reg [1:0] ones_count;   // Count of 1's in current window (0-3)

    // State transition
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Window control
    wire window_complete = (cycle_count == 2'd2);
    wire evaluate_window = (state == B) && (cycle_count == 2'd0);

    // Output logic
    assign z = evaluate_window && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            ones_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update cycle counter (mod 3)
                cycle_count <= window_complete ? 2'd0 : (cycle_count + 1'b1);

                // Update ones counter only during window (not at evaluation)
                if (!evaluate_window) begin
                    ones_count <= (cycle_count == 2'd0) ? w : (ones_count + w);
                end
            end else begin
                // Reset counters in state A
                cycle_count <= 2'd0;
                ones_count <= 2'd0;
            end
        end
    end

endmodule