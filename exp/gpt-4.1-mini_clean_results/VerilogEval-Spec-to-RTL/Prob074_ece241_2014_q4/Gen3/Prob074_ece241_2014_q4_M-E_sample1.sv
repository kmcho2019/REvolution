module TopModule (
    input  clk,
    input  rst,  // synchronous reset input, active high
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    wire ff_and_n = ~ff_and;
    wire ff_or_n  = ~ff_or;

    wire d_xor = x ^ ff_xor;
    wire d_and = x & ff_and_n;
    wire d_or  = x | ff_or_n;

    always @(posedge clk) begin
        if (rst) begin
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
        end else begin
            ff_xor <= d_xor;
            ff_and <= d_and;
            ff_or  <= d_or;
        end
    end

    assign z = ~(ff_xor | ff_and | ff_or);

endmodule