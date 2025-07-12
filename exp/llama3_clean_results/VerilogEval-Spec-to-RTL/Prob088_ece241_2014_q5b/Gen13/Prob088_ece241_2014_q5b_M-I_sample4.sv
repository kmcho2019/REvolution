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
            2'b01: 
                if(x) begin
                    state <= 2'b10; // Transition from A to B
                end else begin
                    state <= 2'b01; // Stay in A
                end
            2'b10: 
                if(x) begin
                    state <= 2'b10; // Stay in B
                end else begin
                    state <= 2'b10; // Stay in B
                end
            default: 
                state <= 2'b01; // Default state
        endcase
    end
end

always @(*) begin
    z = (state == 2'b10) || (state == 2'b01 && x == 1'b1); // Simplified logic for 'z'
end

endmodule