module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // States: 0 - A, 1 - B Checking, 2 - B (setting output based on count)
reg [1:0] count; // Counter for w = 1 in three cycles
reg [1:0] cycle; // Cycle counter for the three-cycle window

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count <= 0;
        cycle <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                end
            end
            1: begin // State B, checking w
                if (w) begin
                    count <= count + 1;
                end
                cycle <= cycle + 1;
                if (cycle == 3) begin
                    state <= 2; // Move to state B, setting output
                end
            end
            2: begin // State B, setting output
                if (count == 2) begin
                    z <= 1;
                end else begin
                    z <= 0;
                end
                state <= 1; // Reset back to checking state
                count <= 0; // Reset counter
                cycle <= 0; // Reset cycle counter
            end
        endcase
    end
end

endmodule