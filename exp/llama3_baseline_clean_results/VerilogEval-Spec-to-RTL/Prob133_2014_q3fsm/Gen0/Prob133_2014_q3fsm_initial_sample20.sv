module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State register (A = 2'b00, B = 2'b01, we use 2 bits for flexibility in adding states if needed)
reg [1:0] w_count; // Counter for w = 1 in state B
reg [1:0] cycle_count; // Counter for clock cycles in state B

always @(posedge clk) begin
    if (reset) begin // Reset condition
        state <= 2'b00; // Go to state A
        w_count <= 0; // Reset w_count
        cycle_count <= 0; // Reset cycle_count
        z <= 0; // Reset output z
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin // Transition to state B when s = 1
                    state <= 2'b01;
                    w_count <= 0; // Reset w_count
                    cycle_count <= 0; // Reset cycle_count
                end
            end
            2'b01: begin // State B
                if (w) begin // If w = 1, increment w_count
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1; // Increment cycle_count
                if (cycle_count == 3) begin // After three clock cycles in state B
                    if (w_count == 2) begin // If w = 1 exactly twice
                        z <= 1; // Set output z to 1
                    end else begin
                        z <= 0; // Otherwise, set output z to 0
                    end
                    w_count <= 0; // Reset w_count for next three cycles
                    cycle_count <= 0; // Reset cycle_count
                end
            end
        endcase
    end
end

endmodule