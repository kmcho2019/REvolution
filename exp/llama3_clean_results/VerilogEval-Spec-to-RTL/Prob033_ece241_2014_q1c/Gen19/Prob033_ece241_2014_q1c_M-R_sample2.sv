// Define the overflow detection module
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);

endmodule

// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [8:0] temp_sum;

    // Perform the addition
    assign temp_sum = {1'b0, a} + {1'b0, b};

    // Check for overflow
    OverflowDetector detector(
      .a(a),
      .b(b),
      .sum(temp_sum[7:0]),
      .overflow(overflow)
    );

    // Assign the result
    assign s = temp_sum[7:0];

endmodule