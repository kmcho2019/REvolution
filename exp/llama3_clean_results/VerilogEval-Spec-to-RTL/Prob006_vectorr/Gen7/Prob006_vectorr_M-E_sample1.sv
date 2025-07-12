// Module to reverse the bit ordering of an 8-bit input using a barrel shifter concept
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // First, swap the two 4-bit halves of the input vector
    wire [3:0] upper_half = in[7:4];
    wire [3:0] lower_half = in[3:0];
    
    // Then, swap individual bits within each half
    assign out[7:4] = {lower_half[0], lower_half[1], lower_half[2], lower_half[3]};
    assign out[3:0] = {upper_half[0], upper_half[1], upper_half[2], upper_half[3]};

    // Further simplify by directly assigning bits without intermediate wires
    // assign out[7:4] = in[3:0];
    // assign out[3:0] = in[7:4];

endmodule