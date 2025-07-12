// Refactored 8-bit Barrel Shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // Define internal wires for shifted inputs
    wire [7:0] shift_1, shift_2, shift_4;

    // Shift by 1 position
    assign shift_1 = {in[6:0], in[7]};

    // Shift by 2 positions
    assign shift_2 = {in[5:0], in[7:6]};

    // Shift by 4 positions
    assign shift_4 = {in[3:0], in[7:4]};

    // Use 2-to-1 multiplexers to select the output
    assign out[0] = ctrl[2] ? shift_4[0] : (ctrl[1] ? shift_2[0] : (ctrl[0] ? shift_1[0] : in[0]));
    assign out[1] = ctrl[2] ? shift_4[1] : (ctrl[1] ? shift_2[1] : (ctrl[0] ? shift_1[1] : in[1]));
    assign out[2] = ctrl[2] ? shift_4[2] : (ctrl[1] ? shift_2[2] : (ctrl[0] ? shift_1[2] : in[2]));
    assign out[3] = ctrl[2] ? shift_4[3] : (ctrl[1] ? shift_2[3] : (ctrl[0] ? shift_1[3] : in[3]));
    assign out[4] = ctrl[2] ? shift_4[4] : (ctrl[1] ? shift_2[4] : (ctrl[0] ? shift_1[4] : in[4]));
    assign out[5] = ctrl[2] ? shift_4[5] : (ctrl[1] ? shift_2[5] : (ctrl[0] ? shift_1[5] : in[5]));
    assign out[6] = ctrl[2] ? shift_4[6] : (ctrl[1] ? shift_2[6] : (ctrl[0] ? shift_1[6] : in[6]));
    assign out[7] = ctrl[2] ? shift_4[7] : (ctrl[1] ? shift_2[7] : (ctrl[0] ? shift_1[7] : in[7]));

endmodule