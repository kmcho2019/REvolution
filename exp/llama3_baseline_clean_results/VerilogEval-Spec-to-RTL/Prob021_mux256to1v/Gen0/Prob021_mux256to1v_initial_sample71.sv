module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    assign out = in[(sel*4)+3] ? 4'b1000 :
                 in[(sel*4)+2] ? 4'b0100 :
                 in[(sel*4)+1] ? 4'b0010 :
                 in[(sel*4)+0] ? 4'b0001 : 4'b0000;

    // Alternatively, we can use a more compact way:
    // assign out = in[(sel*4)+:4];

endmodule