module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter; // Counter for 3 cycles
reg count_w; // Flag to count occurrences of w = 1
reg state; // State flag: 0 for A, 1 for B

always @(posedge clk) begin
    if (reset) begin // Reset condition
        state <= 0; // Reset to state A
        counter <= 0;
        count_w <= 0;
        z <= 0;
    end else begin
        if (state == 0) begin // State A
            if (s) begin // Move to state B
                state <= 1;
                counter <= 1; // Start counter for 3 cycles
                count_w <= 0; // Reset count for w occurrences
            end
        end else begin // State B
            if (counter < 3) begin // Within the 3 cycles
                counter <= counter + 1; // Increment counter
                if (w) begin // If w = 1, increment count
                    count_w <= count_w + 1;
                end
            end else begin // After 3 cycles
                counter <= 0; // Reset counter
                if (count_w == 2) begin // If w = 1 exactly twice
                    z <= 1; // Set z to 1
                end else begin
                    z <= 0; // Otherwise, set z to 0
                end
                count_w <= 0; // Reset count for next cycle
            end
        end
    end
end

endmodule