module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    // Direct implementation using assign statement (minimal overhead)
    assign out_assign = a & b;

    // Clear always block implementation with proper sensitivity list
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule