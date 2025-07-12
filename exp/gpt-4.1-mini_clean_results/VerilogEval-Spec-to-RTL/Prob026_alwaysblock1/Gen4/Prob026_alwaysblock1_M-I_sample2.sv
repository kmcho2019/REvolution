module TopModule (
    input a,
    input b,
    output reg out_alwaysblock,
    output out_assign
);

    // AND gate implemented with assign statement
    assign out_assign = a & b;

    // AND gate implemented with combinational always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule