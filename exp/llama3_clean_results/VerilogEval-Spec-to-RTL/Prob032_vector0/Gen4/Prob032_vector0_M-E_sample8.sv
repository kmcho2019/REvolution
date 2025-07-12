module TopModule #(
    parameter VECTOR_LENGTH = 3
)(
    input  [VECTOR_LENGTH-1:0] vec,
    output [VECTOR_LENGTH-1:0] outv,
    output [VECTOR_LENGTH-1:0] o
);

assign outv = vec;
assign o = vec;

endmodule

module TopModuleWrapper(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

TopModule #(.VECTOR_LENGTH(3)) top_module (
   .vec(vec),
   .outv(outv),
   .o({o2, o1, o0})
);

endmodule