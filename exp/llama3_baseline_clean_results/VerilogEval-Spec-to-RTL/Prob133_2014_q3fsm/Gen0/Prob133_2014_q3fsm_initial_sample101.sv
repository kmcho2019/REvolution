module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // Using 2 bits for 4 states (A, B1, B2, B3)
reg [1:0] w_count; // Counter for w = 1
reg [1:0] cycle_count; // Counter for clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Transition to state B1
                end else begin
                    state <= 2'b00; // Stay in A
                end
                w_count <= 0;
                cycle_count <= 0;
                z <= 0;
            end
            2'b01: begin // State B1
                if (w) begin
                    w_count <= w_count + 1;
                end
                cycle_count <= cycle_count + 1;
                if (cycle_count == 3) begin
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= 2'b01; // Stay in B1 for continuous monitoring
                    w_count <= 0;
                    cycle_count <= 0;
                end else begin
                    state <= 2'b01; // Continue in B1
                end
            end
            default: begin
                state <= 2'b00; // Default to state A
                w_count <= 0;
                cycle_count <= 0;
                z <= 0;
            end
        endcase
    end
end

endmodule