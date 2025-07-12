module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign directly implements AND operation
    assign out_assign = a & b;

    // Combinational always block implements AND operation separately
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule