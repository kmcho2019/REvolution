module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Assign the result of the addition using a full adder module
    wire [7:0] sum;
    assign sum = a + b;

    // Assign the result of the addition
    assign s = sum;

    // Detect signed overflow
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

    // Optional: Full adder module for modularity and potential scalability
    // module full_adder(
    //     input  a,  // input bit
    //     input  b,  // input bit
    //     input  cin,  // carry-in
    //     output sum,  // sum bit
    //     output cout  // carry-out
    // );

    //     // Calculate the sum and carry-out
    //     assign sum = a ^ b ^ cin;
    //     assign cout = (a & b) | (a & cin) | (b & cin);

    // endmodule

endmodule