module TopModule (
    input  a,
    input  b,
    output reg out_assign,
    output out_alwaysblock
);

    wire and_result;

    always @(*) begin
        and_result = a & b;
        out_assign = and_result;
    end

    assign out_alwaysblock = a & b;

endmodule