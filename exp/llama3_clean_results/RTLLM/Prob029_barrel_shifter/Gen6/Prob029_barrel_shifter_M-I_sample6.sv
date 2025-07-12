module barrel_shifter(
    input [7:0] in, 
    input [2:0] ctrl, 
    output [7:0] out
);

    wire [7:0] shift4;
    wire [7:0] shift2;
    wire [7:0] shift1;

    // Shift by 4 positions
    assign shift4 = {in[3:0], in[7:4]};

    // Shift by 2 positions
    assign shift2 = (ctrl[1])? {in[1:0], in[7:2]} : in;

    // Shift by 1 position
    assign shift1 = (ctrl[0])? {in[0], in[7:1]} : ((ctrl[1])? shift2 : in);

    // Determine the final output based on the control signals
    assign out = (ctrl[2])? shift4 : ((ctrl[1])? shift2 : ((ctrl[0])? shift1 : in));

endmodule