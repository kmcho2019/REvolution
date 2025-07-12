// Novel module to calculate the even parity bit for an 8-bit input byte using a recursive approach
module ParityCalc(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the parity of the first 4 bits
wire parity_first_half;
ParityCalc4Bits first_half_calc(
    .in(in[7:4]),
    .parity(parity_first_half)
);

// Calculate the parity of the second 4 bits
wire parity_second_half;
ParityCalc4Bits second_half_calc(
    .in(in[3:0]),
    .parity(parity_second_half)
);

// Calculate the overall parity by XORing the parities of the two halves
assign parity = parity_first_half ^ parity_second_half;

endmodule

// Module to calculate the parity of a 4-bit input
module ParityCalc4Bits(
    input  [3:0] in,  // 4-bit input
    output parity    // 1-bit output for even parity
);

// Calculate the parity of the first 2 bits
wire parity_first_two;
ParityCalc2Bits first_two_calc(
    .in(in[3:2]),
    .parity(parity_first_two)
);

// Calculate the parity of the second 2 bits
wire parity_second_two;
ParityCalc2Bits second_two_calc(
    .in(in[1:0]),
    .parity(parity_second_two)
);

// Calculate the overall parity by XORing the parities of the two 2-bit halves
assign parity = parity_first_two ^ parity_second_two;

endmodule

// Module to calculate the parity of a 2-bit input
module ParityCalc2Bits(
    input  [1:0] in,  // 2-bit input
    output parity    // 1-bit output for even parity
);

// Calculate the parity by XORing the two bits
assign parity = in[1] ^ in[0];

endmodule