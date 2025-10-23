module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Define the internal wires
    wire [7:0] shifted_by_4;
    wire [7:0] shifted_by_2;
    wire [7:0] shifted_by_1;

    // Shift by 4 positions if ctrl[2] is high
    assign shifted_by_4 = (ctrl[2] == 1'b1) ? {in[3:0], 4'b0000} : in;

    // Shift by 2 positions if ctrl[1] is high
    assign shifted_by_2 = (ctrl[1] == 1'b1) ? {shifted_by_4[5:0], 2'b00} : shifted_by_4;

    // Shift by 1 position if ctrl[0] is high
    assign shifted_by_1 = (ctrl[0] == 1'b1) ? {shifted_by_2[6:0], 1'b0} : shifted_by_2;

    // The final output is the result after all shifts
    assign out = shifted_by_1;

endmodule