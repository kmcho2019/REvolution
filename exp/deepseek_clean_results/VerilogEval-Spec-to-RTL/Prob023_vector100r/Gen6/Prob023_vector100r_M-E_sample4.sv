module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Reverse 10-bit chunks and their order
    assign out = {
        {in[9:0]},    // Chunk 0 becomes chunk 9
        {in[19:10]},  // Chunk 1 becomes chunk 8
        {in[29:20]},  // Chunk 2 becomes chunk 7
        {in[39:30]},  // Chunk 3 becomes chunk 6
        {in[49:40]},  // Chunk 4 becomes chunk 5
        {in[59:50]},  // Chunk 5 becomes chunk 4
        {in[69:60]},  // Chunk 6 becomes chunk 3
        {in[79:70]},  // Chunk 7 becomes chunk 2
        {in[89:80]},  // Chunk 8 becomes chunk 1
        {in[99:90]}   // Chunk 9 becomes chunk 0
    };

endmodule