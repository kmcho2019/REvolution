module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1) and state B (0)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
        z <= 1'b0; // Reset output to 0
    end else begin
        case(state)
            1'b1: begin
                state <= x? 1'b0 : 1'b1;
                z <= x? 1'b1 : 1'b0;
            end
            1'b0: begin
                state <= 1'b0;
                z <= ~x;
            end
        endcase
    end
end

endmodule