module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Using wire type for internal signal to ensure optimization
    wire [2:0] a_not = ~a;
    wire [2:0] b_not = ~b;

    assign out_or_bitwise = a | b;
    // Alternative implementation for logical OR using reduction OR
    assign out_or_logical = |a || |b;
    assign out_not = {b_not, a_not};

endmodule