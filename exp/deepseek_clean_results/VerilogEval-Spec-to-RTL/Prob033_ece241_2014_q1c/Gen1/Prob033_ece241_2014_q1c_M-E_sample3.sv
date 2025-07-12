module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum_with_carry;
    wire carry_in_msb, carry_out_msb;
    
    // Carry-save addition with extended bit for carry out
    assign sum_with_carry = {1'b0, a} + {1'b0, b};
    assign s = sum_with_carry[7:0];
    
    // Overflow detection using carry bits
    assign carry_in_msb = sum_with_carry[7];  // Carry into MSB
    assign carry_out_msb = sum_with_carry[8]; // Carry out of MSB
    assign overflow = carry_in_msb ^ carry_out_msb;
endmodule