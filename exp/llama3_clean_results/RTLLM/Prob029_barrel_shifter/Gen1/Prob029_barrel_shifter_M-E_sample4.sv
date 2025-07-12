module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input [7:0] in;
    input [2:0] ctrl;

    wire [7:0] shifted_in;

    // Perform shift by 4 positions if ctrl[2] is high
    assign shifted_in = (ctrl[2]) ? {in[3:0], 4'b0000} : in;

    // Perform shift by 2 positions if ctrl[1] is high
    wire [7:0] shifted_in_2;
    assign shifted_in_2 = (ctrl[1]) ? {shifted_in[1:0], 6'b000000} : shifted_in;

    // Perform shift by 1 position if ctrl[0] is high
    assign out = (ctrl[0]) ? {shifted_in_2[6:0], shifted_in_2[7]} : shifted_in_2;
endmodule