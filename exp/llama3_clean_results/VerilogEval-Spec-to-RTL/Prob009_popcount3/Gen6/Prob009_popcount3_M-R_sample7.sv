module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Intermediate wires to hold the contribution of each bit to the count
    wire [1:0] bit0_contribution, bit1_contribution, bit2_contribution;

    // Use bitwise AND with a '1' to check for '1's in each position
    assign bit0_contribution = in[0]? 2'b01 : 2'b00;
    assign bit1_contribution = in[1]? 2'b01 : 2'b00;
    assign bit2_contribution = in[2]? 2'b01 : 2'b00;

    // Sum the contributions of each bit to get the total count
    assign out = bit0_contribution + bit1_contribution + bit2_contribution;

endmodule