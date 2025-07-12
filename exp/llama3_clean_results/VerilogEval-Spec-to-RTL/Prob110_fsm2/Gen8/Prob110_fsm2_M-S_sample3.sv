module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg out; // state and output

always @(posedge clk or posedge areset) begin
    if (areset) begin
        out <= 1'b0; // Reset to OFF state
    end else begin
        case (out)
            1'b0: out <= j ? 1'b1 : 1'b0; // Transition from OFF to ON on j=1
            1'b1: out <= k ? 1'b0 : 1'b1; // Transition from ON to OFF on k=1
            default: out <= 1'b0;
        endcase
    end
end

endmodule