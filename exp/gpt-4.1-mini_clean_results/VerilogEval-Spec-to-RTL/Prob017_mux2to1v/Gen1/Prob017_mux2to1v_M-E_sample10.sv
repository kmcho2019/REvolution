module BitMux2to1(
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : mux_array
            BitMux2to1 bm (
                .in0(a[i]),
                .in1(b[i]),
                .sel(sel),
                .out(out[i])
            );
        end
    endgenerate
endmodule