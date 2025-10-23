// Define a module for the binary addition stage using a carry-lookahead adder
module binary_adder_cla(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [4:0] bin_sum
);
    wire [3:0] sum;
    wire Cout;
    
    // Calculate sum and carry for each bit position
    assign sum[0] = A[0] ^ B[0] ^ Cin;
    assign Cout = (A[0] & B[0]) | (A[0] & Cin) | (B[0] & Cin);
    
    assign sum[1] = A[1] ^ B[1] ^ Cout;
    assign Cout = (A[1] & B[1]) | (A[1] & Cout) | (B[1] & Cout);
    
    assign sum[2] = A[2] ^ B[2] ^ Cout;
    assign Cout = (A[2] & B[2]) | (A[2] & Cout) | (B[2] & Cout);
    
    assign sum[3] = A[3] ^ B[3] ^ Cout;
    assign Cout = (A[3] & B[3]) | (A[3] & Cout) | (B[3] & Cout);
    
    assign bin_sum = {Cout, sum};
endmodule

// Define a module for the BCD correction stage
module bcd_corrector(
    input [4:0] bin_sum,
    output [3:0] Sum,
    output Cout
);
    localparam BCD_CORRECTION = 4'd6;
    assign Cout = (bin_sum > 4'd9) ? 1'b1 : 1'b0;
    assign Sum = (bin_sum > 4'd9) ? (bin_sum[3:0] + BCD_CORRECTION) : bin_sum[3:0];
endmodule

// Top-level module for the 4-bit BCD adder with optimized stages
module adder_bcd_optimized(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [4:0] bin_sum;
    
    // Instantiate the optimized binary addition stage
    binary_adder_cla u_add(
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