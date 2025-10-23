module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign performs AND directly
    assign out_assign = a & b;

    // Combinational always block performs AND directly
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule