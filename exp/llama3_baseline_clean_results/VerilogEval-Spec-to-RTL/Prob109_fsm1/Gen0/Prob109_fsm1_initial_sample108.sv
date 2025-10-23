module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

reg [0:0] state; // Using 1 bit to represent two states: 0 for A and 1 for B

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset to state B
    end else begin
        case(state)
            1'b1: // State B
                begin
                    if (in == 1'b0) begin
                        state <= 1'b0; // Transition to A
                    end else begin
                        state <= 1'b1; // Stay in B
                    end
                end
            1'b0: // State A
                begin
                    if (in == 1'b0) begin
                        state <= 1'b1; // Transition to B
                    end else begin
                        state <= 1'b0; // Stay in A
                    end
                end
        endcase
    end
end

always @(state) begin
    case(state)
        1'b0: out <= 1'b1; // Output is 1 when in state A
        1'b1: out <= 1'b0; // Output is 0 when in state B
    endcase
end

endmodule