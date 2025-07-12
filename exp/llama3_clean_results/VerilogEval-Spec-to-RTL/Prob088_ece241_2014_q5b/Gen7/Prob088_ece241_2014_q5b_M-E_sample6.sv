module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // Binary encoding for states A (0) and B (1)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        case(state)
            1'b0: // State A
                if(x) begin
                    state <= 1'b1; // Transition to B
                end
            1'b1: // State B
                state <= 1'b1; // Stay in B
            default:
                state <= 1'b0; // Default to A
        endcase
    end
end

always @(*) begin
    case(state)
        1'b0: // State A
            if(x) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
        1'b1: // State B
            z = ~x;
        default:
            z = 1'b0; // Default output
    endcase
end

endmodule