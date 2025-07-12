module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
        out <= 1'b0;   // Directly reset output for clarity
    end else begin
        case(state)
            1'b0: state <= j ? 1'b1 : 1'b0; // OFF to ON or stay OFF
            1'b1: state <= ~k ? 1'b1 : 1'b0; // ON to OFF or stay ON
        endcase
        // Directly assigning out based on state for potential optimization
        out <= state;
    end
end

endmodule