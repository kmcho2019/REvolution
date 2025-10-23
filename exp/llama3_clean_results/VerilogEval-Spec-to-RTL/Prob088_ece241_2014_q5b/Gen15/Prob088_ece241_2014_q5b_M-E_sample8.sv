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
            2'b01: state <= x ? 2'b10 : 2'b01; // Transition from A to B or stay in A
            2'b10: state <= 2'b10; // Stay in B
        endcase
    end
end

always @(*) begin
    z = (state == 2'b01) ? x : 1'b1; // Simplified logic for 'z'
end

endmodule