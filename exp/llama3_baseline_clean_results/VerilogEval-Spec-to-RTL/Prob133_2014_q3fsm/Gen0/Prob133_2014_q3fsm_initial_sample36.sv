module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A (0) and State B (1)
reg [2:0] w_count; // Counter for w = 1 in the last three clock cycles
reg [2:0] clock_count; // Counter for clock cycles in State B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to State A
        w_count <= 0;
        clock_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to State B
                    clock_count <= 1;
                    w_count <= w;
                end
            end
            1: begin // State B
                if (clock_count < 3) begin
                    clock_count <= clock_count + 1;
                    w_count <= {w_count[1:0], w};
                end else begin
                    if (w_count[2:0] == 2'b10 || w_count[2:0] == 2'b01 || w_count[2:0] == 3'b11) begin
                        z <= 1; // Set z to 1 if w = 1 in exactly two clock cycles
                    end else begin
                        z <= 0;
                    end
                    clock_count <= 1; // Reset clock count for next three cycles
                    w_count <= w; // Reset w_count for next three cycles
                end
            end
        endcase
    end
end

endmodule