module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0 - A, 1 - B Examining, 2 - B Counting
reg [2:0] w_count; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for the three clock cycles
reg z_next; // Next value of z

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    w_count <= 0;
                    cycle_count <= 1;
                end
            end
            1: begin // State B Examining
                if (w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if (cycle_count == 3) begin
                    state <= 2; // Transition to state B Counting
                    z_next <= (w_count == 2) ? 1 : 0;
                end
            end
            2: begin // State B Counting
                z <= z_next;
                state <= 1; // Back to state B Examining
                w_count <= 0;
                cycle_count <= 1;
            end
            default: state <= 0;
        endcase
    end
end

endmodule