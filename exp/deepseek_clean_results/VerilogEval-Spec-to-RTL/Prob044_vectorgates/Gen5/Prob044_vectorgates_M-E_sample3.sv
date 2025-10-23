module VectorProcessor #(parameter WIDTH = 3) (
    input [WIDTH-1:0] vec_a,
    input [WIDTH-1:0] vec_b,
    output [WIDTH-1:0] bitwise_or,
    output logical_or,
    output [2*WIDTH-1:0] inverted
);
    // Compute NOT operations first (reverse order)
    wire [WIDTH-1:0] not_a = ~vec_a;
    wire [WIDTH-1:0] not_b = ~vec_b;
    
    // Bitwise OR using NOT-NOR optimization
    assign bitwise_or = ~(not_a & not_b);
    
    // Logical OR using reduced NOT values (more efficient)
    assign logical_or = |vec_a || |vec_b;
    
    // Concatenate inverted vectors
    assign inverted = {not_b, not_a};
endmodule

module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Instantiate parameterized vector processor
    VectorProcessor #(.WIDTH(3)) vproc (
        .vec_a(a),
        .vec_b(b),
        .bitwise_or(out_or_bitwise),
        .logical_or(out_or_logical),
        .inverted(out_not)
    );
endmodule