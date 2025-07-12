module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Declare wires for intermediate shifted values
    wire [7:0] shift_1;
    wire [7:0] shift_2;
    wire [7:0] shift_4;

    // Assign values to intermediate shifted wires
    assign shift_1 = {in[6:0], in[7]}; // shift by 1 position
    assign shift_2 = {in[5:0], in[7:6]}; // shift by 2 positions
    assign shift_4 = {in[4:0], in[7:5]}; // shift by 4 positions

    // Use assign statement to connect intermediate wires to output based on control signal
    assign out = (ctrl[2]) ? shift_4 :
                 (ctrl[1]) ? shift_2 :
                 (ctrl[0]) ? shift_1 :
                 in; // no shift

endmodule