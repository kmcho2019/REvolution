module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1'b0) and state B (1'b1)

always @(*) begin
    // Combinational logic for output 'z'
    if(state) begin // State B
        z = ~x;
    end else begin // State A
        z = x;
    end
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        case({state, x})
            2'b00: state <= 1'b0; // Stay in A when x=0
            2'b01: state <= 1'b1; // Move to B when x=1
            2'b10, 2'b11: state <= 1'b1; // Stay in B regardless of x
        endcase
    end
end

endmodule