module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg state; // 0 for state A, 1 for state B

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        case(state)
            1'b0: state <= x? 1'b1 : 1'b0; // Transition from A to B or stay in A
            1'b1: state <= 1'b1; // Stay in B
        endcase
    end
end

assign z = (state == 1'b0) ? x : ~x; // Simplified logic for 'z'

endmodule