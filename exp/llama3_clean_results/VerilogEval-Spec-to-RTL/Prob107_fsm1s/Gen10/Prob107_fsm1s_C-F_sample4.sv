module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b1; // Reset state is B, represented by binary '1'
    end else begin
        case(state)
            1'b1: state <= in ? 1'b1 : 1'b0; // State B
            1'b0: state <= in ? 1'b0 : 1'b1; // State A
            default: state <= 1'b1; // Default state
        endcase
    end
end

always @(*) begin
    out = state; // Output is directly related to the state
end

endmodule