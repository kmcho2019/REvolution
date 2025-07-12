module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment implements AND gate
    assign out_assign = a & b;

    // Combinational always block independently computes AND
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule