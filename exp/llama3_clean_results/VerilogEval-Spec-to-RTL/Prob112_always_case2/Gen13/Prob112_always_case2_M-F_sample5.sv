module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

// The output pos is assigned based on the priority of the input bits.
// If the most significant bit (in[3]) is '1', pos is 2'b11 (3 in decimal).
// If in[3] is '0' but in[2] is '1', pos is 2'b10 (2 in decimal).
// If both in[3] and in[2] are '0' but in[1] is '1', pos is 2'b01 (1 in decimal).
// If none of the above conditions are met (i.e., in[0] is '1' or all bits are '0'), pos defaults to 2'b00 (0 in decimal).
assign pos = 
    (in[3])? 2'b11 : 
    (in[2])? 2'b10 : 
    (in[1])? 2'b01 : 
    (in[0])? 2'b00 :  // Explicitly handle the case when all bits are '0'
    2'b00;

endmodule