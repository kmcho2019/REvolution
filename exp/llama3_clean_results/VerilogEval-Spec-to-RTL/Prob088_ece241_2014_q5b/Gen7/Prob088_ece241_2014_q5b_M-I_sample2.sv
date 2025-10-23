module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoded state register

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        case(state)
            2'b01: begin // State A
                if(x) begin
                    state <= 2'b10; // Transition to state B
                end else begin
                    state <= 2'b01; // Stay in state A
                end
            end
            2'b10: begin // State B
                state <= 2'b10; // Stay in state B
            end
            default: state <= 2'b01; // Default to state A
        endcase
    end
end

always @(*) begin
    case(state)
        2'b01: begin // State A
            z = x;
        end
        2'b10: begin // State B
            z = ~x;
        end
        default: z = 1'b0; // Default output
    endcase
end

endmodule