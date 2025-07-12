module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // Current state (0 for A, 1-3 for B)
reg w_count; // Counter for 'w' values

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B
                    w_count <= w; // Initialize w_count
                end
                else begin
                    z <= 0;
                end
            end
            1, 2: begin // State B (clock cycles 1 and 2)
                state <= state + 1; // Increment state
                w_count <= w_count + w; // Increment 'w' count
                z <= 0; // 'z' remains 0 during the count
            end
            3: begin // State B (clock cycle 3)
                z <= (w_count == 2); // Set 'z' based on 'w' count
                state <= 1; // Reset state
                w_count <= w; // Reset 'w' count with current 'w' value
            end
        endcase
    end
end

endmodule