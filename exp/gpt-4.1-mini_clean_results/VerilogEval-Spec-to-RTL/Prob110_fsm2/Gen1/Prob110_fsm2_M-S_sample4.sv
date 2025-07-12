module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding: OFF=0, ON=1
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;             // OFF state
        else if (out == 1'b0)        // currently OFF
            out <= j ? 1'b1 : 1'b0; // move to ON if j=1, else stay OFF
        else                         // currently ON
            out <= k ? 1'b0 : 1'b1; // move to OFF if k=1, else stay ON
    end

endmodule