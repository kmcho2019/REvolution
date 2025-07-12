// Define a module for the lower 4-bit binary addition
module lower_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] sum
);
    assign sum = A + B + Cin;
endmodule

// Define a module for the carry-out generation
module carry_generator(
    input [3:0] sum,
    output Cout
);
    assign Cout = (sum > 4'd9);
endmodule

// Define a module for the BCD correction
module bcd_corrector(
    input [3:0] sum,
    input Cout,
    output [3:0] corrected_sum
);
    localparam BCD_CORRECTION = 4'd6;
    assign corrected_sum = (Cout == 1'b1) ? (sum + BCD_CORRECTION) : sum;
endmodule

// Top-level module for the 4-bit BCD adder
module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [3:0] lower_sum;
    wire Cout_int;
    
    // Instantiate the lower 4-bit binary addition stage
    lower_adder u_lower_add(
       .A(A),
       .B(B),
       .Cin(Cin),
       .sum(lower_sum)
    );
    
    // Instantiate the carry-out generation stage
    carry_generator u_carry_gen(
       .sum(lower_sum),
       .Cout(Cout_int)
    );
    
    // Instantiate the BCD correction stage
    bcd_corrector u_correct(
       .sum(lower_sum),
       .Cout(Cout_int),
       .corrected_sum(Sum)
    );
    
    assign Cout = Cout_int;
endmodule