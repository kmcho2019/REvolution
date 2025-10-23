// Define a module for the binary addition stage
module binary_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [4:0] bin_sum
);
    assign bin_sum = {Cin, A} + {1'b0, B};
endmodule

// Define a module for the BCD correction stage
module bcd_corrector(
    input [4:0] bin_sum,
    output [3:0] Sum,
    output Cout
);
    wire [3:0] temp_sum = bin_sum[3:0];
    assign Sum = (temp_sum > 4'd9) ? temp_sum + 4'd6 : temp_sum;
    assign Cout = (temp_sum > 4'd9) || bin_sum[4];
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