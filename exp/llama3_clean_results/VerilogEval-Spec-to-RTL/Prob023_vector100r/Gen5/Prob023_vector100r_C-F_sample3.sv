module TopModule(
    input  [99:0] in,
    output [99:0] out
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        assign out[i] = in[99 - i]; // Reversing the bits using a generate block for conciseness and efficiency
    end
endgenerate

endmodule