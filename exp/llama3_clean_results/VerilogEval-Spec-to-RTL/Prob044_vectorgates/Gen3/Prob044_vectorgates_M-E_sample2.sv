// Top-level module
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] inv_a, inv_b;
    wire [2:0] bitwise_or;

    // Bitwise operation stage
    assign bitwise_or = a | b;
    assign inv_a = ~a;
    assign inv_b = ~b;

    // Logical operation stage
    assign out_or_logical = (bitwise_or != 3'b000);
    assign out_or_bitwise = bitwise_or;
    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule