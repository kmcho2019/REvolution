module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoded state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset into state A
    end else begin
        case (state)
            2'b01: begin // State A
                if (x == 1'b0) begin
                    state <= 2'b01; // Stay in state A
                end else begin
                    state <= 2'b10; // Transition to state B
                end
            end
            2'b10: begin // State B
                state <= 2'b10; // Stay in state B
            end
            default: begin
                state <= 2'b01; // Default to state A
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                z = 1'b0;
            end else begin
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            z = x ? 1'b0 : 1'b1;
        end
        default: begin
            z = 1'b0;
        end
    endcase
end

endmodule