module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry;  // One extra bit for the input carry and output carry
    
    assign carry[0] = cin;
    
    // Generate sum and carry for each bit
    assign sum = a ^ b ^ carry[7:0];
    assign carry[8:1] = (a & b) | (a & carry[7:0]) | (b & carry[7:0]);
    
    assign cout = carry[8];

endmodule