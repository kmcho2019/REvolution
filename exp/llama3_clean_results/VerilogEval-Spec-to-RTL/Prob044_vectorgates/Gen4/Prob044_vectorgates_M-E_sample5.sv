// Top-level module with pipeline architecture
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    // Stage 1: Bitwise OR operation
    wire [2:0] bitwise_or_result;
    assign bitwise_or_result = a | b;

    // Stage 2: Logical OR operation
    assign out_or_logical = (bitwise_or_result != 3'b000);

    // Stage 3: Inversion of input vectors
    assign out_not[5:3] = ~b;
    assign out_not[2:0] = ~a;

    // Output the bitwise OR result
    assign out_or_bitwise = bitwise_or_result;
endmodule