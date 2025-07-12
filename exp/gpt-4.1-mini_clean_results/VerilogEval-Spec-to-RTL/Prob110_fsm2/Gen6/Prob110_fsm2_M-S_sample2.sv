module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0; // OFF state on reset
        else if (out == 1'b0)
            out <= j ? 1'b1 : 1'b0;
        else // out == 1
            out <= k ? 1'b0 : 1'b1;
    end

endmodule