module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign out[i] = (~sel & a[i]) | (sel & b[i]);
        end
    endgenerate

endmodule