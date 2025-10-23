module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1; // Reset to state B (out=1)
    end else begin
        case(state)
            0: state <= ~in; // State A
            1: state <= in ? 1 : 0; // State B
        endcase
    end
end

assign out = ~state; // Output is directly related to the state

endmodule