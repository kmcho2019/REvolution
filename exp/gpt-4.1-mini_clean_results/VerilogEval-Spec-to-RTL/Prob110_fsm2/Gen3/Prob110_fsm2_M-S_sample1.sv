module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;            // OFF state
        else if (out == 1'b0)
            out <= j ? 1'b1 : 1'b0; // OFF state transitions on j
        else
            out <= k ? 1'b0 : 1'b1; // ON state transitions on k
    end

endmodule