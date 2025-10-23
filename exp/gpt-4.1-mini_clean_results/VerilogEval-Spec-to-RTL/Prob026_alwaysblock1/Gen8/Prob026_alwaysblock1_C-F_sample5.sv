module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign directly computes AND
    assign out_assign = a & b;

    // Combinational always block directly computes AND with blocking assignment
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule