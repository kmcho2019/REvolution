module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count; // Counter for w = 1 occurrences
reg [1:0] cycle; // Cycle counter for 3 clock cycles
reg state; // State variable (0 for A, 1 for B)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count <= 0; // Reset counter
        cycle <= 0; // Reset cycle counter
        z <= 0; // Reset output
    end else begin
        if (state == 0) begin // State A
            if (s == 1) begin
                state <= 1; // Move to state B
            end
            z <= 0; // Ensure z is 0 in state A
        end else begin // State B
            if (cycle < 2) begin // First three cycles
                if (w == 1) begin
                    count <= count + 1; // Increment counter if w = 1
                end
                cycle <= cycle + 1; // Increment cycle counter
            end else begin // Fourth cycle
                if (count == 2) begin
                    z <= 1; // Set z if count is exactly 2
                end else begin
                    z <= 0; // Otherwise, clear z
                end
                cycle <= 0; // Reset cycle counter
                count <= 0; // Reset counter for next set of cycles
            end
        end
    end
end

endmodule