module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    input         en,    // Added enable signal for power optimization
    output [99:0] out
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : mux_gen
            assign out[i] = en ? (sel ? b[i] : a[i]) : 1'b0;
        end
    endgenerate

endmodule