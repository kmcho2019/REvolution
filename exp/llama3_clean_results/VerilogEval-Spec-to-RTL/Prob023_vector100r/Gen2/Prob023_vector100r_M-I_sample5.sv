module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);

    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            assign out[99 - i] = in[i];
        end
    endgenerate

endmodule