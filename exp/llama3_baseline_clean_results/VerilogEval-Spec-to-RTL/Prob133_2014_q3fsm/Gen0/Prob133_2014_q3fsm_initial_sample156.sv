module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable (A=0, B=1)
reg [1:0] count; // Counter for clock cycles in state B
reg [1:0] w_count; // Counter for w=1 in state B

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset state to A
        count <= 0; // Reset counter
        w_count <= 0; // Reset w counter
        z <= 0; // Reset output
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    count <= 1; // Initialize counter
                    w_count <= w ? 1 : 0; // Initialize w counter
                end
            end
            1: begin // State B
                count <= count + 1; // Increment counter
                if (w) begin
                    w_count <= w_count + 1; // Increment w counter if w=1
                end
                if (count == 3) begin // Check after three clock cycles
                    if (w_count == 2) begin
                        z <= 1; // Set z=1 if w was 1 exactly twice
                    end else begin
                        z <= 0; // Otherwise, set z=0
                    end
                    count <= 1; // Reset counter
                    w_count <= w ? 1 : 0; // Reset w counter
                end
            end
        endcase
    end
end

endmodule