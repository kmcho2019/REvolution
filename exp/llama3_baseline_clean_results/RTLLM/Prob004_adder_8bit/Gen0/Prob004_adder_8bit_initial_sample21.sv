// Full adder module
module full_adder(
    input a, 
    input b, 
    input cin, 
    output sum, 
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [6:0] carry;
    
    // Instantiate full adder for the least significant bit
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);
    
    // Instantiate full adders for the remaining bits
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(a[i], b[i], carry[i-1], sum[i], carry[i]);
        end
    endgenerate
    
    // The carry-out of the most significant bit is the final carry-out
    assign cout = carry[7];
endmodule