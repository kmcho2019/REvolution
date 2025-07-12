module OneBitMux (
    input  wire sel,
    input  wire a,
    input  wire b,
    output wire out
);
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire        sel,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_mux
            OneBitMux mux_inst (
                .sel(sel),
                .a(a[i]),
                .b(b[i]),
                .out(out[i])
            );
        end
    endgenerate
endmodule