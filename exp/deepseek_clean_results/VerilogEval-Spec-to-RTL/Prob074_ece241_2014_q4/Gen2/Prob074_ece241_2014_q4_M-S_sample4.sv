module TopModule (
    input clk,
    input x,
    output z
);

    reg dff_xor, dff_and, dff_or;

    always @(posedge clk) begin
        dff_xor <= x ^ dff_xor;
        dff_and <= x & ~dff_and;
        dff_or  <= x | ~dff_or;
    end

    assign z = ~(dff_xor | dff_and | dff_or);

endmodule