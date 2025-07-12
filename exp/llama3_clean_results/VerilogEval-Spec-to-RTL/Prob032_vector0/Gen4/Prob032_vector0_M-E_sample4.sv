module TopModule #(
    parameter WIDTH = 3
)(
    input  [WIDTH-1:0] vec,
    output [WIDTH-1:0] outv,
    output [WIDTH-1:0] out_bits
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use a for-loop to assign the individual bits
genvar i;
generate
    for (i = 0; i < WIDTH; i++) begin
        assign out_bits[i] = vec[i];
    end
endgenerate

endmodule

module WrapperModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Instantiate the parameterized module
TopModule #(.WIDTH(3)) top_module (
   .vec(vec),
   .outv(outv),
   .out_bits({o2, o1, o0})
);

endmodule