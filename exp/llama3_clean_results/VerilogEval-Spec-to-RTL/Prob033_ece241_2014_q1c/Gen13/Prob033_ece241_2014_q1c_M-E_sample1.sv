// Define the hybrid adder module
module HybridAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output      overflow  
);

    // Lower 4-bit adder using standard cell libraries
    wire [3:0] lower_sum;
    wire       lower_cout;

    RippleCarryAdder lower_adder(
        .a(a[3:0]),
        .b(b[3:0]),
        .sum(lower_sum),
        .cout(lower_cout)
    );

    // Upper 4-bit adder with redundancy-checking mechanism
    wire [3:0] upper_sum;
    wire       upper_cout;
    wire       overflow_flag;

    RedundancyChecker upper_adder(
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(lower_cout),
        .sum(upper_sum),
        .cout(upper_cout),
        .overflow(overflow_flag)
    );

    // Combine the lower and upper sum
    assign sum = {upper_sum, lower_sum};

    // Detect overflow
    assign overflow = overflow_flag;

endmodule

// Define the ripple-carry adder module
module RippleCarryAdder(
    input  [3:0] a,  
    input  [3:0] b,  
    output [3:0] sum,  
    output      cout  
);

    wire [3:0] temp_sum;
    wire [2:0] temp_cout;

    assign temp_sum[0] = a[0] ^ b[0];
    assign temp_cout[0] = a[0] & b[0];

    assign temp_sum[1] = a[1] ^ b[1] ^ temp_cout[0];
    assign temp_cout[1] = (a[1] & b[1]) | (a[1] & temp_cout[0]) | (b[1] & temp_cout[0]);

    assign temp_sum[2] = a[2] ^ b[2] ^ temp_cout[1];
    assign temp_cout[2] = (a[2] & b[2]) | (a[2] & temp_cout[1]) | (b[2] & temp_cout[1]);

    assign temp_sum[3] = a[3] ^ b[3] ^ temp_cout[2];
    assign cout = (a[3] & b[3]) | (a[3] & temp_cout[2]) | (b[3] & temp_cout[2]);

    assign sum = temp_sum;

endmodule

// Define the redundancy-checker module
module RedundancyChecker(
    input  [3:0] a,  
    input  [3:0] b,  
    input       cin,  
    output [3:0] sum,  
    output      cout,  
    output      overflow  
);

    wire [3:0] temp_sum;
    wire       temp_cout;

    assign temp_sum[0] = a[0] ^ b[0] ^ cin;
    assign temp_cout = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    assign sum[0] = temp_sum[0];
    assign cout = temp_cout;

    assign sum[1] = a[1] ^ b[1] ^ temp_cout;
    assign sum[2] = a[2] ^ b[2] ^ temp_cout;
    assign sum[3] = a[3] ^ b[3] ^ temp_cout;

    assign overflow = (a[3] != b[3]) && ((a[3] == 1 && sum[3] == 0) || (a[3] == 0 && sum[3] == 1));

endmodule