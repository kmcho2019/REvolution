module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // Using [0:0] for a single bit to match synthesis guidelines
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case(state)
            1'b1: begin // State B
                if (!in) begin
                    state <= 1'b0; // Transition to state A
                end
            end
            1'b0: begin // State A
                if (!in) begin
                    state <= 1'b1; // Transition to state B
                end
            end
            default: state <= 1'b1; // Default to state B for any other value
        endcase
    end
end

assign out = state; // Directly assign state to output

endmodule