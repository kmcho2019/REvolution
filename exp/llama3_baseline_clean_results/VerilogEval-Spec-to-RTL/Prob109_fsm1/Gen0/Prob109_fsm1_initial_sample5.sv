module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using a single bit for state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset to state B
    end else begin
        case (state)
            1'b0: // State A
                case (in)
                    1'b0: state <= 1; // Go to state B
                    1'b1: state <= 0; // Stay in state A
                endcase
            1'b1: // State B
                case (in)
                    1'b0: state <= 0; // Go to state A
                    1'b1: state <= 1; // Stay in state B
                endcase
        endcase
    end
end

assign out = state; // Output is the same as the state

endmodule