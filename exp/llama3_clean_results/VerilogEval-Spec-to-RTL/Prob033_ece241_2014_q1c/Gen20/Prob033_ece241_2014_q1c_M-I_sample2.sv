// Define the full adder module with optimized logic for lower power consumption
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);
    
    // Calculate the sum and carry-out using optimized logic
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the ripple-carry adder module
module RippleCarryAdder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);

    // Internal wires for the ripple-carry adder
    wire [7:0] cout;

    // Initialize the carry-in for the LSB
    assign cout[0] = 1'b0;

    // Calculate the sum and carry-out for each bit position
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(cout[i]),
                .sum(sum[i]),
                .cout(cout[i+1])
            );
        end
    endgenerate

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

    RippleCarryAdder adder(
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