module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [16:0] carry;
    
    assign carry[0] = Cin;
    
    assign y = a ^ b ^ carry[15:0];
    assign carry[16:1] = (a & b) | (a & carry[15:0]) | (b & carry[15:0]);
    assign Co = carry[16];
endmodule