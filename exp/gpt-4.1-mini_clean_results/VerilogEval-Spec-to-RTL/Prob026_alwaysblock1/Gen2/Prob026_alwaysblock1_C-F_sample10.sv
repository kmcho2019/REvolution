module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Implement AND with assign statement
    assign out_assign = a & b;

    // Implement AND with combinational always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule