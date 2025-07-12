module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding for state A (2'b01) and state B (2'b10)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case(state)
            2'b01: state <= x? 2'b10 : 2'b01; // Transition from A to B or stay in A
            2'b10: state <= 2'b10; // Stay in B
        endcase
    end
end

always @(posedge clk) begin
    if (state == 2'b01) begin
        z <= x;
    end else if (state == 2'b10) begin
        z <= ~x;
    end
end

endmodule