// Define a module for the binary addition stage
module binary_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [4:0] bin_sum
);
    assign bin_sum = A + B + Cin;
endmodule

// Define a module for the BCD correction stage
module bcd_corrector(
    input [4:0] bin_sum,
    output [3:0] Sum,
    output Cout
);
    localparam BCD_CORRECTION = 4'd6;
    assign Cout = (bin_sum > 9);
    assign Sum = (bin_sum > 9)? (bin_sum[3:0] + BCD_CORRECTION) : bin_sum[3:0];
endmodule

// Top-level module for the 4-bit BCD adder
module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [4:0] bin_sum;
    
    // Instantiate the binary addition stage
    binary_adder u_add(
       .A(A),
       .B(B),
       .Cin(Cin),
       .bin_sum(bin_sum)
    );
    
    // Instantiate the BCD correction stage
    bcd_corrector u_correct(
       .bin_sum(bin_sum),
       .Sum(Sum),
       .Cout(Cout)
    );
endmodule