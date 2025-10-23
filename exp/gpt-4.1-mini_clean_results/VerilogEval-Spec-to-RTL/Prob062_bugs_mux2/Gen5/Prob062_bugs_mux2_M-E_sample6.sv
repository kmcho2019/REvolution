module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_bit
            assign out[i] = sel ? b[i] : a[i];
        end
    endgenerate

endmodule