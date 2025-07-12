module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using 1 bit for state

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case(state)
            1'b0: state <= j ? 1'b1 : state; // If in OFF state, move to ON if j=1
            1'b1: state <= k ? 1'b0 : state; // If in ON state, move to OFF if k=1
        endcase
    end
end

assign out = state; // Assign output based on state

endmodule