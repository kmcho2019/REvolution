module BitMux2to1(
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);
    assign out = sel ? b : a;
endmodule

module TopModule(
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);
    genvar i;
    generate
        for (i=0; i<100; i=i+1) begin : mux_array
            BitMux2to1 bit_mux(
                .a(a[i]),
                .b(b[i]),
                .sel(sel),
                .out(out[i])
            );
        end
    endgenerate
endmodule