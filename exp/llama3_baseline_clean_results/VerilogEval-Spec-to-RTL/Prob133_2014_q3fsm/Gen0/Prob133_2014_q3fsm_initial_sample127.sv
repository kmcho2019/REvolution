module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // 0 - A, 1 - B Waiting, 2 - B Checking
reg [1:0] count_w; // Counts w=1 occurrences
reg [1:0] cycle_count; // Counts cycles since entering B
reg z_reg; // Register for output z

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count_w <= 0;
        cycle_count <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    cycle_count <= 1; // Start counting cycles
                    count_w <= w ? 1 : 0; // Initialize w count
                end else begin
                    state <= 0; // Stay in A
                end
                z_reg <= 0; // Ensure z is 0 in A
            end
            1: begin // State B, first cycle
                if (cycle_count < 3) begin
                    cycle_count <= cycle_count + 1; // Increment cycle count
                    if (w) begin
                        count_w <= count_w + 1; // Increment w count if w=1
                    end
                    state <= 1; // Stay in B
                end else begin
                    // Check count_w to set z
                    if (count_w == 2) begin
                        z_reg <= 1;
                    end else begin
                        z_reg <= 0;
                    end
                    // Reset counters and move back to waiting
                    cycle_count <= 1;
                    count_w <= w ? 1 : 0;
                    state <= 1; // Stay in B for next check
                end
            end
            default: state <= 0; // Invalid state, reset to A
        endcase
    end
end

assign z = z_reg;

endmodule