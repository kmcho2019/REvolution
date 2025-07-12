module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // AND gate using continuous assignment
    assign out_assign = a & b;

    // AND gate using combinational always block
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule