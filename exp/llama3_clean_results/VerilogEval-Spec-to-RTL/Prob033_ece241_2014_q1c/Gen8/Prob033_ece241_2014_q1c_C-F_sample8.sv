// Define the adder module
module EightBitAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    assign sum = a + b;

endmodule

// Define the overflow detection module
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    assign overflow = (a[7] == b[7] && a[7] != sum[7]);

endmodule

// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;

    EightBitAdder adder(
        .a(a),
        .b(b),
        .sum(sum)
    );

    OverflowDetector detector(
        .a(a),
        .b(b),
        .sum(sum),
        .overflow(overflow)
    );

    assign s = sum;

endmodule