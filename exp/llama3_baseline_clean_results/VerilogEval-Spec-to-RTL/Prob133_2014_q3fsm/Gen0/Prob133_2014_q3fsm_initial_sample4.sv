module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] count_w; // Counter for 'w=1' occurrences
reg [1:0] cycle_count; // Counter for the current cycle within the 3-cycle window
reg z_reg; // Register for output z

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count_w <= 0;
        cycle_count <= 0;
        z_reg <= 0;
    end else begin
        case(state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    count_w <= 0;
                    cycle_count <= 1;
                end
            end
            1: begin // State B
                if (w) begin
                    count_w <= count_w + 1; // Increment count if w=1
                end
                cycle_count <= cycle_count + 1; // Increment cycle count
                if (cycle_count == 3) begin // After 3 cycles
                    z_reg <= (count_w == 2); // Set z based on count
                    count_w <= 0; // Reset count for next 3 cycles
                    cycle_count <= 1; // Reset cycle count
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule