module TopModule (
    input  a,
    input  b,
    output reg out_assign,
    output reg out_alwaysblock
);

    // Combinational always block driving out_assign
    always @(*) begin
        out_assign = a & b;
    end

    // Combinational always block driving out_alwaysblock
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule