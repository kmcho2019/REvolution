module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out // Declare out as reg to assign values
);

reg state; // 1-bit signal to represent the current state

always @(posedge areset or posedge clk) begin
    if(areset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        // State transitions
        case(state)
            1'b0: state <= j? 1'b1 : 1'b0; // Transition from OFF to ON based on j
            1'b1: state <= k? 1'b0 : 1'b1; // Transition from ON to OFF based on k
        endcase
    end
end

always @(state) begin
    out = state; // Output is directly based on the current state
end

endmodule