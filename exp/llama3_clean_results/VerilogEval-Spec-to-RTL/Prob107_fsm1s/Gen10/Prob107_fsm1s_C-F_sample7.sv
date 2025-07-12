module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit state variable

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset to state B
    end else begin
        case(state)
            1'b0: state <= in ? 1'b0 : 1'b1; // State B
            1'b1: state <= in ? 1'b1 : 1'b0; // State A
            default: state <= 1'b0; // Default state
        endcase
    end
end

assign out = ~state; // Output is directly related to the state

endmodule