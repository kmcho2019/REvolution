module TopModule #(
    parameter WIDTH = 3
)(
    input [WIDTH-1:0] vec,
    output [WIDTH-1:0] outv,
    output [WIDTH-1:0] o
);

    assign outv = vec;
    assign o = vec;

endmodule

module top (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    wire [2:0] o;
    TopModule #(.WIDTH(3)) inst (
       .vec(vec),
       .outv(outv),
       .o(o)
    );

    assign o2 = o[2];
    assign o1 = o[1];
    assign o0 = o[0];

endmodule