module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg state; // 1-bit signal to represent the current state

always @(posedge areset or posedge clk) begin
    if(areset) begin
        state <= 1'b0; // Reset to OFF state
        out <= 1'b0; // Reset output to 0
    end else begin
        case(state)
            1'b0: begin
                state <= j? 1'b1 : 1'b0; // Transition from OFF to ON based on j
                out <= j? 1'b1 : 1'b0; // Update output based on state
            end
            1'b1: begin
                state <= k? 1'b0 : 1'b1; // Transition from ON to OFF based on k
                out <= k? 1'b0 : 1'b1; // Update output based on state
            end
        endcase
    end
end

endmodule