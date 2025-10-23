module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset state is B, represented by binary '0'
    end else begin
        case(state)
            1'b0: state <= in ? 1'b0 : 1'b1; // State B
            1'b1: state <= in ? 1'b1 : 1'b0; // State A
            default: state <= 1'b0; // Default state
        endcase
    end
end

always @(*) begin
    case(state)
        1'b0: out = 1'b1; // Output is 1 in state B
        1'b1: out = 1'b0; // Output is 0 in state A
        default: out = 1'b0; // Default output
    endcase
end

endmodule