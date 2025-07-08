module TopModule (
    input  wire [254:0] in,
    output wire [7:0] out
);

    // Split input into 8 groups: 7 groups of 32 bits and 1 group of 31 bits
    // Count number of 1's in each group and sum them
    wire [5:0] count0, count1, count2, count3, count4, count5, count6; // 32 bits => max 32 ones, 6 bits needed
    wire [5:0] count7; // 31 bits => max 31 ones

    // Population count for each chunk
    assign count0 =  in[31:0]  - {{31{1'b0}},1'b0};  // dummy assign to avoid warnings
    assign count1 =  in[63:32] - {{31{1'b0}},1'b0};
    assign count2 =  in[95:64] - {{31{1'b0}},1'b0};
    assign count3 = in[127:96] - {{31{1'b0}},1'b0};
    assign count4 = in[159:128] - {{31{1'b0}},1'b0};
    assign count5 = in[191:160] - {{31{1'b0}},1'b0};
    assign count6 = in[223:192] - {{31{1'b0}},1'b0};
    assign count7 = in[254:224] - {{31{1'b0}},1'b0};

    // The above are placeholders; we need to implement population count for each chunk.
    // Implement a function for population count for 32-bit and 31-bit inputs.

    function [5:0] popcount32;
        input [31:0] val;
        integer i;
        begin
            popcount32 = 0;
            for (i=0; i<32; i=i+1)
                popcount32 = popcount32 + val[i];
        end
    endfunction

    function [5:0] popcount31;
        input [30:0] val;
        integer i;
        begin
            popcount31 = 0;
            for (i=0; i<31; i=i+1)
                popcount31 = popcount31 + val[i];
        end
    endfunction

    wire [5:0] c0 = popcount32(in[31:0]);
    wire [5:0] c1 = popcount32(in[63:32]);
    wire [5:0] c2 = popcount32(in[95:64]);
    wire [5:0] c3 = popcount32(in[127:96]);
    wire [5:0] c4 = popcount32(in[159:128]);
    wire [5:0] c5 = popcount32(in[191:160]);
    wire [5:0] c6 = popcount32(in[223:192]);
    wire [5:0] c7 = popcount31(in[254:224]);

    // Sum all partial counts
    wire [8:0] sum1 = c0 + c1 + c2 + c3;
    wire [8:0] sum2 = c4 + c5 + c6 + c7;
    wire [8:0] total = sum1 + sum2;

    assign out = total[7:0];

endmodule