module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Both outputs driven from the same always block
    always @(*) begin
        out_alwaysblock = a & b;
        assign out_assign = a & b;
    end
endmodule