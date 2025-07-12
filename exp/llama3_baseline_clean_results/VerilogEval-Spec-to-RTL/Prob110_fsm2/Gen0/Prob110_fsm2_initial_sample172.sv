module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg state; // State variable: 0 for OFF, 1 for ON

always @(*) begin
    if (areset) begin
        state <= 0; // Reset to OFF state when areset is high
    end else begin
        case (state)
            0: state <= j ? 1 : 0; // If in OFF state, transition to ON if j=1
            1: state <= ~k ? 1 : 0; // If in ON state, stay if k=0, else go to OFF
        endcase
    end
end

always @(posedge clk) begin
    out <= state; // Assign output based on the current state
end

endmodule