module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // Using 2 bits for one-hot encoding
reg [1:0] nextState;

always @(*) begin
    case(state)
        2'b10: // State A
            if(x) begin
                nextState = 2'b01; // Move to B
                z = 1'b1;
            end else begin
                nextState = 2'b10; // Stay in A
                z = 1'b0;
            end
        2'b01: // State B
            if(x) begin
                nextState = 2'b01; // Stay in B
                z = 1'b0;
            end else begin
                nextState = 2'b01; // Stay in B
                z = 1'b1;
            end
        default:
            nextState = 2'b10; // Reset state
            z = 1'b0;
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b10; // Asynchronous reset to state A
    end else begin
        state <= nextState;
    end
end

endmodule