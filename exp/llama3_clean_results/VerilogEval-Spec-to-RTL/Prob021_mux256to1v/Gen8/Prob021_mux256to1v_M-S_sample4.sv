module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the offset within the 1024-bit input vector
    wire [9:0] offset;
    assign offset = {sel[7:4], sel[3:0]} * 4'd4;

    // Select the 4-bit group from the input vector
    assign out = in[offset +: 4];

endmodule