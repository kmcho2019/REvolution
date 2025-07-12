module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // Encoding for states: 1 for B, 0 for A

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Reset to B
    end else begin
        case (state)
            1'b1: // State B
                state <= ~in ? 1'b0 : 1'b1;
            1'b0: // State A
                state <= in ? 1'b0 : 1'b1;
            default: state <= 1'b1; // Default to B if state becomes invalid
        endcase
    end
end

assign out = state;

endmodule