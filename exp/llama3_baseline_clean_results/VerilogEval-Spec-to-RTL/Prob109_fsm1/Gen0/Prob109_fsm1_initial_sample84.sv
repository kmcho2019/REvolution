module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

reg [0:0] state; // Using 1 bit to represent the states (A=0, B=1)

always @(*) begin
    case (state)
        1'b0: out = 1'b0; // State A output is 0
        1'b1: out = 1'b1; // State B output is 1
        default: out = 1'b0; // Default output is 0
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Asynchronous reset to state B
    end else begin
        case (state)
            1'b0: state <= (in)? 1'b0 : 1'b1; // State A transitions
            1'b1: state <= (in)? 1'b1 : 1'b0; // State B transitions
            default: state <= 1'b1; // Default to state B
        endcase
    end
end

endmodule