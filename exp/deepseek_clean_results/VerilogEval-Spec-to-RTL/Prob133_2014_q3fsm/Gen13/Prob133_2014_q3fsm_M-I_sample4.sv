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

    // Tracking registers (optimized for area)
    reg [1:0] counter;
    reg [1:0] ones_count;  // Replaces w_samples (counts 1s directly)

    // State transition logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Window evaluation signals (optimized timing)
    wire window_complete = counter[1] & ~counter[0];  // counter == 2
    wire evaluate = (state == B) && (counter == 2'd0);
    
    // Partial sums for timing optimization
    wire partial_sum = ones_count[0] + ones_count[1];
    
    // Output assignment (now purely combinational)
    assign z = evaluate && (partial_sum == 2'd2);

    // Sequential logic with power optimizations
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            counter <= 2'd0;
            ones_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == B) begin
                // Update counter mod 3
                counter <= window_complete ? 2'd0 : counter + 1'd1;

                // Update ones count only when window isn't complete
                if (!window_complete) begin
                    ones_count <= ones_count + w;
                end else begin
                    // Reset count at window boundary
                    ones_count <= w;  // First sample of new window
                end
            end else begin
                // Reset tracking in state A
                counter <= 2'd0;
                ones_count <= 2'd0;
            end
        end
    end

endmodule