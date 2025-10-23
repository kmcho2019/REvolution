module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    // Using a generate block for a more concise and scalable implementation
    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            assign out[99 - i] = in[i];
        end
    endgenerate

endmodule