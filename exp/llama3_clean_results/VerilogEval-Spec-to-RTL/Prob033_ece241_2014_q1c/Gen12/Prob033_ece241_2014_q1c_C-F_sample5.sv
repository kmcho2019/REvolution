// Define the full adder module
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);

    // Calculate the sum and carry-out
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the PrefixSumAdder module
module PrefixSumAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    wire [7:0] cout;
    wire [7:0] psum;

    // Instantiate BitPairAdders
    full_adder bit0(.a(a[0]),.b(b[0]),.cin(1'b0),.sum(sum[0]),.cout(cout[0]));
    full_adder bit1(.a(a[1]),.b(b[1]),.cin(cout[0]),.sum(sum[1]),.cout(cout[1]));
    full_adder bit2(.a(a[2]),.b(b[2]),.cin(cout[1]),.sum(sum[2]),.cout(cout[2]));
    full_adder bit3(.a(a[3]),.b(b[3]),.cin(cout[2]),.sum(sum[3]),.cout(cout[3]));
    full_adder bit4(.a(a[4]),.b(b[4]),.cin(cout[3]),.sum(sum[4]),.cout(cout[4]));
    full_adder bit5(.a(a[5]),.b(b[5]),.cin(cout[4]),.sum(sum[5]),.cout(cout[5]));
    full_adder bit6(.a(a[6]),.b(b[6]),.cin(cout[5]),.sum(sum[6]),.cout(cout[6]));
    full_adder bit7(.a(a[7]),.b(b[7]),.cin(cout[6]),.sum(sum[7]),.cout(cout[7]));

    // Calculate prefix sums in a hierarchical manner
    assign psum[0] = cout[0];
    assign psum[1] = cout[1] | psum[0];
    assign psum[2] = cout[2] | psum[1];
    assign psum[3] = cout[3] | psum[2];
    assign psum[4] = cout[4] | psum[3];
    assign psum[5] = cout[5] | psum[4];
    assign psum[6] = cout[6] | psum[5];
    assign psum[7] = cout[7] | psum[6];

endmodule

// Define the overflow detection module
module OverflowDetector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);

    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);

endmodule

// TopModule that integrates the PrefixSumAdder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    wire [7:0] sum;

    PrefixSumAdder prefix_sum_adder(
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