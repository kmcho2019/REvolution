module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B1, 2: B2 (simplified to just two states: A=0, B=1,2)
reg [1:0] count; // Count of clock cycles in state B
reg w_count;     // Count of w=1 in state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    count <= 1; // Start counting clock cycles
                    w_count <= w; // Initialize w_count
                end else begin
                    state <= 0; // Stay in A
                end
                z <= 0; // z is always 0 in state A
            end
            1: begin // State B1
                count <= count + 1; // Increment clock cycle count
                if (w) begin
                    w_count <= w_count + 1; // Increment w_count if w=1
                end
                if (count == 3) begin // After 3 clock cycles
                    state <= 1; // Stay in B (now B2 effectively)
                    count <= 1; // Reset clock cycle count
                    if (w_count == 2) begin // If w=1 exactly twice
                        z <= 1; // Set z=1 in the next cycle
                    end else begin
                        z <= 0; // Otherwise, z=0
                    end
                    w_count <= w; // Reset w_count for next 3 cycles
                end else begin
                    state <= 1; // Continue in B
                    if (count == 2) begin
                        z <= 0; // z=0 until decision is made
                    end
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule