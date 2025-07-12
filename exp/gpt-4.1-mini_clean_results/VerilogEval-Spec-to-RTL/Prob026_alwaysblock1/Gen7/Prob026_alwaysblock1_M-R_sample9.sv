module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    reg and_result;

    always @(*) begin
        and_result = a & b;
        out_alwaysblock = a & b;
    end

    assign out_assign = and_result;

endmodule