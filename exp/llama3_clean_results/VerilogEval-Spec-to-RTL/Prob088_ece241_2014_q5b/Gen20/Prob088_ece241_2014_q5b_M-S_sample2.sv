module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // Binary encoding for states A (0) and B (1)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        case(state)
            1'b0: state <= x; // Transition from A to B or stay in A
            1'b1: state <= 1'b1; // Stay in B
        endcase
    end
end

always @(*) begin
    z = (state == 1'b0)? x : ~x; // Simplified logic for 'z'
end

endmodule