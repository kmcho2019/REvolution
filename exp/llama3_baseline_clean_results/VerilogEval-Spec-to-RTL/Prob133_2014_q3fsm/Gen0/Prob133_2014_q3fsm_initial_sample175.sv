module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] count; // Counter for cycles in State B
reg [1:0] w_count; // Counter for w=1 in State B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to State A
        count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to State B
                    count <= 1; // Start counting cycles
                    w_count <= w ? 1 : 0; // Count w=1
                end
                z <= 0; // Ensure z is 0 in State A
            end
            1: begin // State B
                count <= count + 1; // Increment cycle count
                if (w) begin
                    w_count <= w_count + 1; // Increment w=1 count
                end
                if (count == 3) begin // End of 3 cycles
                    if (w_count == 2) begin
                        z <= 1; // Set z=1 if w=1 exactly twice
                    end else begin
                        z <= 0; // Otherwise, z=0
                    end
                    count <= 1; // Reset cycle count for next check
                    w_count <= w ? 1 : 0; // Reset w=1 count
                    if (~s) begin // If s=0, return to State A
                        state <= 0;
                        z <= 0; // Ensure z=0 when returning to State A
                    end
                end
            end
            default: begin
                state <= 0; // Default to State A
                count <= 0;
                w_count <= 0;
                z <= 0;
            end
        endcase
    end
end

endmodule