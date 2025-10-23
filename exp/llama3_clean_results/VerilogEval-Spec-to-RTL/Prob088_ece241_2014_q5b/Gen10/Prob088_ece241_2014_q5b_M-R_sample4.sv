module TopModule(
    input clk,
    input areset,
    input x,
    output reg [1:0] z // changed to reg to accommodate assign
);

reg [1:0] state; // One-hot encoding for states A and B

assign z = (state == 2'b01) ? {1'b0, x} : {1'b1, x}; // Simplified output generation

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case(state)
            2'b01: state <= (x) ? 2'b10 : 2'b01; // Transition from state A
            2'b10: state <= 2'b10; // Stay in state B
            default: state <= 2'b01; // Default to state A
        endcase
    end
end

endmodule