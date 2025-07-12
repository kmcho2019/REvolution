module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // State A (2'b00) and State B (2'b01, 2'b10, 2'b11)
reg [2:0] w_count; // Counter for w = 1 in three cycles
reg [2:0] cycle_count; // Counter for the three cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        w_count <= 3'b000; // Reset w_count
        cycle_count <= 3'b000; // Reset cycle_count
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Move to State B
                    w_count <= w ? 1 : 0; // Initialize w_count based on w
                    cycle_count <= 1; // Start cycle count
                end
            end
            default: begin // State B
                if (cycle_count == 3) begin // End of three cycles
                    state <= 2'b01; // Reset state for next three cycles
                    w_count <= w ? 1 : 0; // Reset w_count for next cycle
                    cycle_count <= 1; // Reset cycle count
                end else begin
                    state <= state + 1; // Increment state for next cycle
                    w_count <= w_count + (w ? 1 : 0); // Increment w_count if w = 1
                    cycle_count <= cycle_count + 1; // Increment cycle count
                end
            end
        endcase
    end
end

assign z = (state == 2'b11 && w_count == 2) || (state == 2'b01 && cycle_count == 1 && w_count == 2);

endmodule