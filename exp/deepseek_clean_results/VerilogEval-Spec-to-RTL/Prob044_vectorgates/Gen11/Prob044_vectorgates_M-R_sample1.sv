module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Bitwise OR operation (3-bit)
    assign out_or_bitwise = a | b;

    // Logical OR operation (1-bit)
    assign out_or_logical = |a || |b;  // Equivalent to |{a,b} but more readable

    // Vector NOT operation (6-bit)
    // b's inverse in upper bits [5:3], a's inverse in lower bits [2:0]
    assign out_not = {~b, ~a};
endmodule