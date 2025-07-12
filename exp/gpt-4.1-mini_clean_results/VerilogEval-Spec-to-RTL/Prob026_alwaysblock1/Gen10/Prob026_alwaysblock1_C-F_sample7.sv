module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_ab = a & b;

    assign out_assign = and_ab;

    always @(*) begin
        out_alwaysblock = and_ab;
    end

endmodule