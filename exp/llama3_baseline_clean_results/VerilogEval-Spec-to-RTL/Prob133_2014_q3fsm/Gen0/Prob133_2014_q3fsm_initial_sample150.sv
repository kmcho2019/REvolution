module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] count_w; // Counter for w occurrences
reg [1:0] cycle_count; // Counter for 3-cycle window
reg in_B; // Flag to indicate if we're in state B

always @(posedge clk or posedge reset) begin
    if (reset) begin
        in_B <= 0;
        count_w <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        if (!in_B && s) begin // Transition from A to B
            in_B <= 1;
            cycle_count <= 1;
        end else if (in_B) begin
            if (cycle_count < 3) begin // Still within the 3-cycle window
                cycle_count <= cycle_count + 1;
                if (w) begin
                    count_w <= count_w + 1;
                end
            end else begin // End of the 3-cycle window
                z <= (count_w == 2); // Set z based on count_w
                cycle_count <= 1; // Reset cycle count
                count_w <= 0; // Reset w count
            end
        end
    end
end

endmodule