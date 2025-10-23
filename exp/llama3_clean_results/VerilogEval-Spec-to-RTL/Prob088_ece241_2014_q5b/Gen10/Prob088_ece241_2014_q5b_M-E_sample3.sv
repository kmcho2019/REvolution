module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding for states A and B

always @(*) begin
    case (state)
        2'b01: // State A
            if (x) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
        2'b10: // State B
            if (x) begin
                z = 1'b0;
            end else begin
                z = 1'b1;
            end
        default: // Invalid state
            z = 1'bx;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case (state)
            2'b01: // State A
                if (x) begin
                    state <= 2'b10; // Transition to state B
                end else begin
                    state <= 2'b01; // Stay in state A
                end
            2'b10: // State B
                state <= 2'b10; // Stay in state B
            default: // Invalid state
                state <= 2'b01; // Reset to state A
        endcase
    end
end

endmodule