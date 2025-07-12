module BitwiseOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] result
);
    assign result = a | b;
endmodule

module LogicalOR #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output result
);
    // Bit-serial OR implementation
    wire [WIDTH-1:0] or_result;
    assign or_result[0] = a[0] | b[0];
    
    genvar i;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : or_chain
            assign or_result[i] = or_result[i-1] | (a[i] | b[i]);
        end
    endgenerate
    
    assign result = or_result[WIDTH-1];
endmodule

module VectorNOT #(parameter WIDTH = 3) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [2*WIDTH-1:0] result
);
    assign result = {~b, ~a};
endmodule

module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Instantiate operation modules
    BitwiseOR #(.WIDTH(3)) bitwise_or (
        .a(a),
        .b(b),
        .result(out_or_bitwise)
    );
    
    LogicalOR #(.WIDTH(3)) logical_or (
        .a(a),
        .b(b),
        .result(out_or_logical)
    );
    
    VectorNOT #(.WIDTH(3)) vector_not (
        .a(a),
        .b(b),
        .result(out_not)
    );
endmodule