module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign output
    assign out_assign = a & b;

    // Combinational always block output
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule