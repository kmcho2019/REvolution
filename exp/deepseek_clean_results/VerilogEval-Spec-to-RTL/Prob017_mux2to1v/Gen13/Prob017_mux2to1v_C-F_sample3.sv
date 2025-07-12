module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    genvar i;
    generate
        for (i = 0; i < 20; i = i + 1) begin : mux_group
            assign out[(i*5)+4:i*5] = sel ? b[(i*5)+4:i*5] : a[(i*5)+4:i*5];
        end
    endgenerate

endmodule