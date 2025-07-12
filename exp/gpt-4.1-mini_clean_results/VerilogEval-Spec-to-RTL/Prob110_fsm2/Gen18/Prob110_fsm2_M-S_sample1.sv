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
        else
            out <= out ? (k ? 1'b0 : 1'b1)  // ON state logic
                       : (j ? 1'b1 : 1'b0); // OFF state logic
    end

endmodule