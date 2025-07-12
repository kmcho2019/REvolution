module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Direct wire assignment - simplest implementation
    assign out_assign = a & b;

    // Combinational always block - clear alternative implementation
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule