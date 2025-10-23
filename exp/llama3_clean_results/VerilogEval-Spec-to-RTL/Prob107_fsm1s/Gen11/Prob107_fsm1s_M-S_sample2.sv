module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Current state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B
    end else begin
        case(state)
            0: state <= in ? 0 : 1; // State B transitions
            1: state <= in ? 1 : 0; // State A transitions
            default: state <= 0; // Default to state B
        endcase
    end
end

always @(*) begin
    case(state)
        0: out = 1; // Output in state B
        1: out = 0; // Output in state A
        default: out = 1; // Default output
    endcase
end

endmodule