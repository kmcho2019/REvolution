module TopModule (
    input [2:0] in,
    output [1:0] out
);
    wire partial_sum, partial_carry;
    wire final_sum, final_carry;
    
    // First half-adder: count bits 0 and 1
    assign partial_sum = in[0] ^ in[1];
    assign partial_carry = in[0] & in[1];
    
    // Second half-adder: add bit 2 to the partial count
    assign final_sum = partial_sum ^ in[2];
    assign final_carry = partial_sum & in[2];
    
    // Combine results
    assign out[0] = final_sum;
    assign out[1] = partial_carry | final_carry;
endmodule