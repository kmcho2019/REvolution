module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg state;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset to state B
    end else begin
        case (state)
            1'b0: // State A
                case (in)
                    1'b0: state <= 1'b1; // Transition to state B on in=0
                    1'b1: state <= 1'b0; // Stay in state A on in=1
                endcase
            1'b1: // State B
                case (in)
                    1'b0: state <= 1'b0; // Transition to state A on in=0
                    1'b1: state <= 1'b1; // Stay in state B on in=1
                endcase
        endcase
    end
end

assign out = state;

endmodule