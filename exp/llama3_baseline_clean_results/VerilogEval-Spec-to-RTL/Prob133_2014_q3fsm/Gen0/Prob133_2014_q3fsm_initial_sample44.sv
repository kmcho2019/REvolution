module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count_w; // Counter for w=1 occurrences
reg [1:0] cycle;   // Cycle counter (0 to 3)
reg in_B;          // Flag to indicate if we are in state B

always @(posedge clk) begin
    if (reset) begin
        in_B <= 0;
        count_w <= 0;
        cycle <= 0;
        z <= 0;
    end else begin
        if (!in_B) begin // State A
            if (s) begin
                in_B <= 1;
                cycle <= 1; // Start counting cycles in state B
            end
        end else begin // State B
            if (cycle < 3) begin // Counting cycles
                cycle <= cycle + 1;
                if (w) begin
                    count_w <= count_w + 1;
                end
            end else begin // End of 3 cycles
                cycle <= 0; // Reset cycle counter
                if (count_w == 2) begin // Check if w=1 exactly twice
                    z <= 1;
                end else begin
                    z <= 0;
                end
                count_w <= 0; // Reset w counter
            end
        end
    end
end

endmodule