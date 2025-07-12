module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result = a & b;

    assign out_assign = and_result;

    always @(*) out_alwaysblock = and_result;

endmodule