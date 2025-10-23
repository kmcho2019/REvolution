module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign directly implementing AND for out_assign
    assign out_assign = a & b;

    // Combinational always block directly computing AND for out_alwaysblock
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule