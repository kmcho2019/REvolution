module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    wire sel_n = ~sel;
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : mux_gen
            assign out[i] = (a[i] & sel_n) | (b[i] & sel);
        end
    endgenerate

endmodule