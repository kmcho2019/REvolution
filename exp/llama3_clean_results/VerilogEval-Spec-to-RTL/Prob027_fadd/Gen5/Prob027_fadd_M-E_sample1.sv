// TopModule: a full adder implemented using two half adders
module TopModule(
    input  a,  // first input bit
    input  b,  // second input bit
    input  cin,  // carry-in bit
    output cout,  // carry-out bit
    output sum  // sum bit
);

// Intermediate signals for the half adder outputs
wire ha_sum;
wire ha_cout;

// First half adder: adds a and b
assign ha_sum = a ^ b;
assign ha_cout = a & b;

// Second half adder: adds the sum of the first half adder and cin
assign sum = ha_sum ^ cin;
assign cout = ha_cout | (ha_sum & cin);

endmodule