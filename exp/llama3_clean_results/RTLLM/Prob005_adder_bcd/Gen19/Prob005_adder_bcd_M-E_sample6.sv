// Define a module for the binary adder
module binary_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [4:0] sum
);
    assign sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};
endmodule

// Define a module for the correction circuit
module correction_circuit(
    input [4:0] sum,
    output [3:0] corrected_sum,
    output Cout
);
    localparam BCD_CORRECTION = 4'd6;
    assign Cout = (sum > 4'd9)? 1'b1 : 1'b0;
    assign corrected_sum = (sum > 4'd9)? (sum[3:0] + BCD_CORRECTION)[3:0] : sum[3:0];
endmodule

// Define the top-level module for the 4-bit BCD adder
module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [4:0] sum;
    
    // Instantiate the binary adder
    binary_adder u_add(
        .A(A),
        .B(B),
        .Cin(Cin),
        .sum(sum)
    );
    
    // Instantiate the correction circuit
    correction_circuit u_correct(
        .sum(sum),
        .corrected_sum(Sum),
        .Cout(Cout)
    );
endmodule