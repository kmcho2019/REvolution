module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 1'b0; // Reset to OFF state
    end else begin
        case (out)
            1'b0: out <= j ? 1'b1 : 1'b0; // If in OFF state, move to ON if j=1
            1'b1: out <= k ? 1'b0 : 1'b1; // If in ON state, move to OFF if k=1
        endcase
    end
end

endmodule