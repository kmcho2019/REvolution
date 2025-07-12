module VectorNOT #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [2*WIDTH-1:0] not_out
);
    // Efficient NOT with concatenation (b in upper bits)
    assign not_out = {~b, ~a};
endmodule

module TopModule #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out_or_bitwise,
    output out_or_logical,
    output [2*WIDTH-1:0] out_not
);
    // Direct bitwise OR for best timing
    assign out_or_bitwise = a | b;
    
    // Single reduction OR for lowest power
    assign out_or_logical = |(a | b);
    
    // Modular NOT implementation
    VectorNOT #(WIDTH) not_ops (
        .a(a),
        .b(b),
        .not_out(out_not)
    );
endmodule