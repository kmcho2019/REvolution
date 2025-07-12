module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // State A = 0, State B = 1
reg [1:0] w_count; // Counter for w = 1 occurrences
reg [1:0] window_count; // Counter for three clock cycles

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        window_count <= 0;
        z <= 0;
    end else begin
        if(state == 0) begin // State A
            if(s) begin
                state <= 1; // Transition to state B
                window_count <= 1; // Start window counter
                w_count <= 0; // Reset w counter
            end
        end else begin // State B
            if(w) begin
                w_count <= w_count + 1; // Increment w counter if w = 1
            end
            window_count <= window_count + 1; // Increment window counter
            if(window_count == 3) begin // End of three clock cycles
                if(w_count == 2) begin // Exactly two w = 1 occurrences
                    z <= 1;
                end else begin
                    z <= 0;
                end
                window_count <= 0; // Reset window counter
                w_count <= 0; // Reset w counter
            end else begin
                z <= 0; // Reset z during the window
            end
        end
    end
end

endmodule