module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [1023:0] shifted_in;
    assign shifted_in = in >> (sel[7:4] * 64 + sel[3:0] * 4);

    assign out = shifted_in[3:0];

endmodule