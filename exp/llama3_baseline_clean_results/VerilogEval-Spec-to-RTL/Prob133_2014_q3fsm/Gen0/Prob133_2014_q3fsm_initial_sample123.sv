module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State register (A=0, B=1, with additional bits for sub-states if needed)
reg [2:0] w_count; // Counter for w pulses in the three clock cycles after entering state B
reg [1:0] cycle_count; // Counter for the three clock cycles

always @(posedge clk) begin
    if (reset) begin // Reset condition
        state <= 0; // Reset to state A
        z <= 0;
        w_count <= 0;
        cycle_count <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin // Transition to state B when s = 1
                    state <= 1; // Move to state B
                    w_count <= 0; // Reset w_count
                    cycle_count <= 0; // Reset cycle_count
                end
            end
            1: begin // State B
                if (w) begin // Increment w_count if w = 1
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1; // Increment cycle_count
                if (cycle_count == 2) begin // At the end of the third cycle
                    z <= (w_count == 2); // Set z based on w_count
                end
                if (cycle_count == 3) begin // Reset for the next sequence
                    cycle_count <= 0;
                    w_count <= 0;
                end
            end
        endcase
    end
end

endmodule