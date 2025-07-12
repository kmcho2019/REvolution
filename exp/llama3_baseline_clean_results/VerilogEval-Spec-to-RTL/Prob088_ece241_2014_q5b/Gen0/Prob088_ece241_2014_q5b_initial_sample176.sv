module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding: A = 2'b01, B = 2'b10

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case (state)
            2'b01: begin // State A
                if (~x) begin
                    state <= 2'b01; // Stay in A if x is 0
                    z <= 1'b0;
                end else begin
                    state <= 2'b10; // Transition to B if x is 1
                    z <= 1'b1;
                end
            end
            2'b10: begin // State B
                if (~x) begin
                    state <= 2'b10; // Stay in B if x is 0
                    z <= 1'b1;
                end else begin
                    state <= 2'b10; // Stay in B if x is 1
                    z <= 1'b0;
                end
            end
            default: begin
                state <= 2'b01; // Default to state A
                z <= 1'b0;
            end
        endcase
    end
end

endmodule