module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input vector into segments for hierarchical counting
    reg [7:0] count1, count2, count3, count4, count5, count6, count7, count8;
    assign count1 = $countones(in[ 63:  0]);
    assign count2 = $countones(in[127: 64]);
    assign count3 = $countones(in[191:128]);
    assign count4 = $countones(in[254:192]);

    // Use a more optimized adder tree for the final summation
    reg [7:0] sum1, sum2;
    assign sum1 = count1 + count2;
    assign sum2 = count3 + count4;
    assign out = sum1 + sum2;

endmodule