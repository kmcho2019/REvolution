// Define the BitPairAdder module
module BitPairAdder(
    input  a,  
    input  b,  
    input  cin,  
    output sum,  
    output cout  
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the PrefixSumNetwork module
module PrefixSumNetwork(
    input  [7:0] cout,  
    output [7:0] psum  
);

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

// Define the FinalSumGenerator module
module FinalSumGenerator(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] psum,  
    output [7:0] sum  
);

    assign sum[0] = a[0] ^ b[0] ^ psum[0];
    assign sum[1] = a[1] ^ b[1] ^ psum[1];
    assign sum[2] = a[2] ^ b[2] ^ psum[2];
    assign sum[3] = a[3] ^ b[3] ^ psum[3];
    assign sum[4] = a[4] ^ b[4] ^ psum[4];
    assign sum[5] = a[5] ^ b[5] ^ psum[5];
    assign sum[6] = a[6] ^ b[6] ^ psum[6];
    assign sum[7] = a[7] ^ b[7] ^ psum[7];

endmodule

// Define the PrefixSumAdder module
module PrefixSumAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output      overflow  
);

    wire [7:0] cout;
    wire [7:0] psum;

    // Instantiate BitPairAdders
    BitPairAdder bit0(.a(a[0]), .b(b[0]), .cin(1'b0), .sum(sum[0]), .cout(cout[0]));
    BitPairAdder bit1(.a(a[1]), .b(b[1]), .cin(cout[0]), .sum(sum[1]), .cout(cout[1]));
    BitPairAdder bit2(.a(a[2]), .b(b[2]), .cin(cout[1]), .sum(sum[2]), .cout(cout[2]));
    BitPairAdder bit3(.a(a[3]), .b(b[3]), .cin(cout[2]), .sum(sum[3]), .cout(cout[3]));
    BitPairAdder bit4(.a(a[4]), .b(b[4]), .cin(cout[3]), .sum(sum[4]), .cout(cout[4]));
    BitPairAdder bit5(.a(a[5]), .b(b[5]), .cin(cout[4]), .sum(sum[5]), .cout(cout[5]));
    BitPairAdder bit6(.a(a[6]), .b(b[6]), .cin(cout[5]), .sum(sum[6]), .cout(cout[6]));
    BitPairAdder bit7(.a(a[7]), .b(b[7]), .cin(cout[6]), .sum(sum[7]), .cout(cout[7]));

    // Instantiate PrefixSumNetwork
    PrefixSumNetwork psum_net(.cout(cout), .psum(psum));

    // Instantiate FinalSumGenerator
    // FinalSumGenerator fsum_gen(.a(a), .b(b), .psum(psum), .sum(sum));

    // Calculate overflow
    assign overflow = (a[7] == b[7] && a[7] != sum[7]);

endmodule

// TopModule that integrates the PrefixSumAdder
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
        .sum(sum),
        .overflow(overflow)
    );

    assign s = sum;

endmodule