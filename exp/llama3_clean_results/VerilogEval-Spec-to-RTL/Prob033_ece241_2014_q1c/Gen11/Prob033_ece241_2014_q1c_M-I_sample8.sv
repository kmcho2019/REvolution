// Define the adder module using straightforward logic
module EightBitAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    assign sum = a + b;

endmodule

// Define the overflow detection module using efficient logic
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);

endmodule

// TopModule that integrates the efficient adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Apply input pipelining to reduce switching activity
    reg [7:0] a_reg;
    reg [7:0] b_reg;
    always @(posedge a or posedge b) begin
        a_reg <= a;
        b_reg <= b;
    end

    wire [7:0] sum;

    EightBitAdder adder(
       .a(a_reg),
       .b(b_reg),
       .sum(sum)
    );

    OverflowDetector detector(
       .a(a_reg),
       .b(b_reg),
       .sum(sum),
       .overflow(overflow)
    );

    assign s = sum;

endmodule