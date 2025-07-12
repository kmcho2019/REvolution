module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // States: 0 - A, 1 - B
reg [1:0] count; // Counter for 3 clock cycles
reg [1:0] w_count; // Counter for w = 1

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to state A
        count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B
                    count <= 1; // Start counting
                    w_count <= w ? 1 : 0; // Initialize w_count
                end
            end
            1: begin // State B
                if(count < 3) begin
                    count <= count + 1; // Increment cycle counter
                    if(w) begin
                        w_count <= w_count + 1; // Increment w counter if w = 1
                    end
                end else begin
                    // Check condition and set z accordingly
                    z <= (w_count == 2) ? 1 : 0;
                    // Reset counters and stay in state B
                    count <= 1;
                    w_count <= w ? 1 : 0;
                end
            end
        endcase
    end
end

endmodule