module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg out_reg;

    always @(posedge clk) begin
        if (reset)
            out_reg <= 1'b0;
        else if (out_reg) begin
            // In ON state - k=1 toggles to OFF
            if (k) out_reg <= 1'b0;
        end
        else begin
            // In OFF state - j=1 toggles to ON
            if (j) out_reg <= 1'b1;
        end
    end

    assign out = out_reg;

endmodule