module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] w_count; // Counts occurrences of w = 1 over 3 cycles
reg [1:0] cycle_count; // Tracks current cycle in 3-cycle window

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to State A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to State B
                    w_count <= 0;
                    cycle_count <= 0;
                end
            end
            1: begin // State B
                cycle_count <= cycle_count + 1;
                if (w) begin
                    w_count <= w_count + 1;
                end
                if (cycle_count == 3) begin // End of 3-cycle window
                    if (w_count == 2) begin
                        z <= 1; // Set z = 1 if w = 1 exactly twice
                    end else begin
                        z <= 0; // Otherwise, z = 0
                    end
                    w_count <= 0; // Reset count for next window
                    cycle_count <= 0; // Reset cycle count
                end
            end
            default: begin
                state <= 0; // Default to State A
            end
        endcase
    end
end

endmodule