module TopModule #(
    parameter VECTOR_SIZE = 3
)(
    input [VECTOR_SIZE-1:0] vec,
    output [VECTOR_SIZE-1:0] outv,
    output [VECTOR_SIZE-1:0] o
);

integer i;

always @(*) begin
    outv = vec;
    for (i = 0; i < VECTOR_SIZE; i++) begin
        o[i] = vec[i];
    end
end

endmodule

module TopModule_wrapper(
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

wire [2:0] o;

TopModule #(.VECTOR_SIZE(3)) top_module(
    .vec(vec),
    .outv(outv),
    .o(o)
);

assign o2 = o[2];
assign o1 = o[1];
assign o0 = o[0];

endmodule