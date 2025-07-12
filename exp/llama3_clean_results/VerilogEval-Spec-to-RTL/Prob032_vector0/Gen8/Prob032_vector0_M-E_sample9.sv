module TopModule #(
    parameter WIDTH = 3
)(
    input  logic [WIDTH-1:0] vec,
    output logic [WIDTH-1:0] outv,
    output logic [WIDTH-1:0] o
);

    assign outv = vec;
    assign o = vec;

endmodule

module TopModule_inst(
    input  logic [2:0] vec,
    output logic [2:0] outv,
    output logic o2,
    output logic o1,
    output logic o0
);

    logic [2:0] o;

    TopModule #(.WIDTH(3)) top_module(
        .vec(vec),
        .outv(outv),
        .o(o)
    );

    assign o2 = o[2];
    assign o1 = o[1];
    assign o0 = o[0];

endmodule