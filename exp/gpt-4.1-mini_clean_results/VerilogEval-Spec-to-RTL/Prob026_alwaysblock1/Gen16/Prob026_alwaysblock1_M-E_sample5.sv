module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment implements AND gate
    assign out_assign = a & b;

    // Combinational always block implements AND gate separately
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule