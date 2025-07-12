module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
        out <= 1'b1; // Directly set output during reset for consistency
    end else begin
        case(state)
            1'b0: state <= in ? 1'b0 : 1'b1; // State A
            1'b1: state <= in ? 1'b1 : 1'b0; // State B
        endcase
        out <= ~state; // Update output based on state
    end
end

endmodule