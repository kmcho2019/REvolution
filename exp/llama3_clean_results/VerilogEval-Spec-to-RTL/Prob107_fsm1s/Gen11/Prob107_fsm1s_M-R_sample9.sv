module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        case(state)
            0: state <= ~in; // State B to A or B based on input
            1: state <= in;  // State A to A or B based on input
            default: state <= 0; // Default state
        endcase
    end
end

always @(*) begin
    case(state)
        0: out = 1; // Output is 1 in state B (0)
        1: out = 0; // Output is 0 in state A (1)
        default: out = 0; // Default output
    endcase
end

endmodule