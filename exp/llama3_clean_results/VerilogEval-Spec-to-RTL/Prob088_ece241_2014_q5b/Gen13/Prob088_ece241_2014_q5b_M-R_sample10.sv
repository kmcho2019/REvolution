module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // Binary encoding for state A (1'b00) and state B (1'b01)

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

assign z = (state == 2'b00)? x : ~x; // Simplified logic for 'z' using binary encoding

endmodule