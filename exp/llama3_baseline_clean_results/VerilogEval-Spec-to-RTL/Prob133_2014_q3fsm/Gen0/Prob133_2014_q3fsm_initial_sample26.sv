module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A (0) and State B (1)
reg [1:0] count_w; // Counter for w = 1 occurrences
reg [2:0] cycle_count; // Counter for the 3-clock cycle window

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to State A
        count_w <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to State B
                    count_w <= 0;
                    cycle_count <= 1;
                end
            end
            1: begin // State B
                if (w) begin
                    count_w <= count_w + 1; // Increment w counter if w = 1
                end
                cycle_count <= cycle_count + 1; // Increment cycle counter
                if (cycle_count == 3) begin // End of 3-cycle window
                    if (count_w == 2) begin // Exactly two w = 1 occurrences
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    count_w <= 0; // Reset w counter
                    cycle_count <= 1; // Reset cycle counter
                end
            end
        endcase
    end
end

endmodule