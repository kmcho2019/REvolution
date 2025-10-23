module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count_w; // Counter for the number of times 'w' is 1
reg [1:0] state; // 0: State A, 1: State B (counting 'w'), 2: State B (output 'z')
reg [2:0] cycle_count; // Counter for the three clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to State A
        count_w <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to State B
                    cycle_count <= 1; // Start cycle count
                    count_w <= 0; // Reset 'w' count
                end
            end
            1: begin // State B (counting 'w')
                if (cycle_count < 3) begin
                    if (w) begin
                        count_w <= count_w + 1; // Increment 'w' count
                    end
                    cycle_count <= cycle_count + 1; // Increment cycle count
                end else begin
                    state <= 2; // Transition to State B (output 'z')
                end
            end
            2: begin // State B (output 'z')
                if (count_w == 2) begin
                    z <= 1; // Set 'z' to 1 if 'w' was 1 exactly twice
                end else begin
                    z <= 0; // Otherwise, set 'z' to 0
                end
                state <= 1; // Return to counting 'w'
                cycle_count <= 1; // Reset cycle count
                count_w <= 0; // Reset 'w' count
            end
        endcase
    end
end

endmodule