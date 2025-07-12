module TopModule(
    input [99:0] in,
    output [99:0] out
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        assign out[99 - i] = in[i];
    end
endgenerate

endmodule