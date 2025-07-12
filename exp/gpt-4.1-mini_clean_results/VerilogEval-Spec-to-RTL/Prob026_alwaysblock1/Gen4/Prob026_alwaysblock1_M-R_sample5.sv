module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Direct continuous assignment for out_assign
    assign out_assign = a & b;

    // Combinational always block directly computing AND
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule