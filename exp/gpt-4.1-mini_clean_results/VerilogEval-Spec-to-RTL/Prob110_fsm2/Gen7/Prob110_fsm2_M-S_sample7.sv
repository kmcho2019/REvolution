module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State register with asynchronous reset and inline next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;  // OFF state
        else if (out == 1'b0)  // OFF state
            out <= j ? 1'b1 : 1'b0;
        else                   // ON state
            out <= k ? 1'b0 : 1'b1;
    end

endmodule