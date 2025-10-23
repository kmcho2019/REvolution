module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding for states A and B
reg [1:0] nextState;

always @(*) begin
    case (state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                nextState = 2'b01; // Stay in state A
                z = 1'b0;
            end else begin
                nextState = 2'b10; // Transition to state B
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            if (x == 1'b0) begin
                nextState = 2'b10; // Stay in state B
                z = 1'b1;
            end else begin
                nextState = 2'b10; // Stay in state B
                z = 1'b0;
            end
        end
        default: begin
            nextState = 2'b01; // Reset to state A
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= nextState;
    end
end

endmodule