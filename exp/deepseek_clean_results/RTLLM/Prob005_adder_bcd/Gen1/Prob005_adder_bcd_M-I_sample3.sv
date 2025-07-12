module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] initial_sum = A + B + Cin;
    wire correction_needed = (initial_sum > 5'd9) | initial_sum[4];
    wire [3:0] correction = {4{correction_needed}} & 4'd6;
    
    assign {Cout, Sum} = initial_sum + {1'b0, correction};
    
endmodule