module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;

    // Intermediate wire computes AND
    assign and_result = a & b;

    // out_assign driven continuously from intermediate wire
    assign out_assign = and_result;

    // out_alwaysblock assigned from intermediate wire inside combinational always block
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule