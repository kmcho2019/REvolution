module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // Binary encoding for states A (2'b00) and B (2'b01)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        case(state)
            2'b00: state <= x? 2'b01 : 2'b00; // Transition from A to B or stay in A
            2'b01: state <= 2'b01; // Stay in B
            default: state <= 2'b00; // Default to state A
        endcase
    end
end

always @(*) begin
    case(state)
        2'b00: z = ~x; // Output 'z' for state A
        2'b01: z = ~x; // Output 'z' for state B
        default: z = 1'b0; // Default output 'z'
    endcase
end

endmodule