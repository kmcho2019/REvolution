module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bit_mux
            assign out[i] = sel ? b[i] : a[i];
        end
    endgenerate
endmodule