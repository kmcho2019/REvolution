module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    reg intermediate_and;

    // Procedural block computes intermediate AND result whenever inputs change
    always @(*) begin
        intermediate_and = a & b;
    end

    // Output assigned continuously from inputs (pure combinational assign)
    assign out_assign = a & b;

    // Output from always block assigned from intermediate reg
    always @(*) begin
        out_alwaysblock = intermediate_and;
    end

endmodule