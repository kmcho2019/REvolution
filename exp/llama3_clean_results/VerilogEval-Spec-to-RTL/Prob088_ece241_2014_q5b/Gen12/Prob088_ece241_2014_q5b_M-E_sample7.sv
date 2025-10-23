module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding for states A and B

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case(state)
            2'b01: state <= x ? 2'b10 : 2'b01; // State A transitions to B if x is 1, otherwise stays in A
            2'b10: state <= 2'b10; // State B stays in B
            default: state <= 2'b01; // Default to state A
        endcase
    end
end

always @(*) begin
    case(state)
        2'b01: z = ~x; // Output z is the inverse of x in state A
        2'b10: z = x; // Output z is the same as x in state B
        default: z = 1'b0; // Default output z to 0
    endcase
end

endmodule