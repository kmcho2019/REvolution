module bit_mux (
    input  sel,
    input  a,
    input  b,
    output out
);
    assign out = sel ? b : a;
endmodule

module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_array
            bit_mux mux_inst (
                .sel(sel),
                .a(a[i]),
                .b(b[i]),
                .out(out[i])
            );
        end
    endgenerate

endmodule