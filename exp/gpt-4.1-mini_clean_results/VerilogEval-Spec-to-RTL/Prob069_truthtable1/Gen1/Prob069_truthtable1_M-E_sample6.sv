module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    wire [7:0] decoder_out;

    // 3-to-8 decoder: decoder_out = 1 at index = {x3,x2,x1}
    assign decoder_out = 8'b00000001 << ({x3, x2, x1});

    // f = OR of decoder outputs for rows where f=1:
    // truth table rows with f=1 are indices: 2(010),3(011),5(101),7(111)
    assign f = decoder_out[2] | decoder_out[3] | decoder_out[5] | decoder_out[7];

endmodule