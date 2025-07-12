module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bitwise_mux
            assign out[i] = (~sel & a[i]) | (sel & b[i]);
        end
    endgenerate
endmodule