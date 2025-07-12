module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] initial_sum = A + B + Cin;
    wire correction_needed = initial_sum[4] | (initial_sum[3] & (initial_sum[2] | initial_sum[1]));
    
    assign {Cout, Sum} = initial_sum + {1'b0, {4{correction_needed}} & 5'b00110;
    
endmodule