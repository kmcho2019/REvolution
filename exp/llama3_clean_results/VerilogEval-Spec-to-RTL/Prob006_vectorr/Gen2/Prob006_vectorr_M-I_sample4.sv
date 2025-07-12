module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    // Using a generate block with a for loop to reverse the bits
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign out[i] = in[7-i];
        end
    endgenerate

endmodule