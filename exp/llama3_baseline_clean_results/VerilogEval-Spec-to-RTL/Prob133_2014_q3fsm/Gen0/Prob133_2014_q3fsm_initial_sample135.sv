module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B Examining, 2: State B Checked
reg [1:0] w_count; // Count of w = 1 in the last 3 cycles
reg [1:0] cycle_count; // Count of cycles since entering State B

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to State A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to State B Examining
                    w_count <= 0;
                    cycle_count <= 0;
                    z <= 0;
                end
            end
            1: begin // State B Examining
                w_count <= w_count + (w ? 1 : 0);
                cycle_count <= cycle_count + 1;
                if (cycle_count == 2) begin // After 3 cycles, move to Checked
                    state <= 2;
                end
            end
            2: begin // State B Checked
                z <= (w_count == 2) ? 1 : 0; // Set z based on w_count
                state <= 1; // Move back to Examining
                w_count <= 0;
                cycle_count <= 0;
            end
        endcase
    end
end

endmodule