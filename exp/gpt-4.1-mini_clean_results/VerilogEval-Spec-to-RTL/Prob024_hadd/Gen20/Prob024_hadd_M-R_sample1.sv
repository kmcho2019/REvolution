module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);
    // Direct combinational logic for half adder using continuous assignment
    assign sum = a ^ b;
    assign cout = a & b;
endmodule