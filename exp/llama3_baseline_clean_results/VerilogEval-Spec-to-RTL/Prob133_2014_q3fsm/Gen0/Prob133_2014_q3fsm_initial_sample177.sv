module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B1, 2: B2, 3: B3
reg [1:0] w_count; // Counter for w highs in the last three cycles

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B1
                    w_count <= 0;
                end else begin
                    state <= 0; // Stay in state A
                end
                z <= 0; // z is 0 in state A
            end
            1: begin // State B1
                state <= 2; // Transition to state B2
                w_count <= w ? 1 : 0; // Update w_count
            end
            2: begin // State B2
                state <= 3; // Transition to state B3
                w_count <= w_count + w; // Update w_count
            end
            3: begin // State B3
                state <= 1; // Transition back to state B1
                z <= (w_count + w) == 2 ? 1 : 0; // Determine z
                w_count <= 0; // Reset w_count
            end
        endcase
    end
end

endmodule