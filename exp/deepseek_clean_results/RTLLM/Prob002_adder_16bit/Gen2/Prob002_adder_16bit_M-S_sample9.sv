module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [16:0] carry_chain;
    
    assign carry_chain[0] = Cin;
    assign y = a ^ b ^ carry_chain[15:0];
    assign carry_chain[16:1] = (a & b) | (a & carry_chain[15:0]) | (b & carry_chain[15:0]);
    assign Co = carry_chain[16];
endmodule