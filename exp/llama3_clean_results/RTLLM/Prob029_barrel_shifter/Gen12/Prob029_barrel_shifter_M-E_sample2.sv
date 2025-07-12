module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // Shift by 1 position
    wire [7:0] shift_1 = {in[6:0], in[7]};

    // Shift by 2 positions
    wire [7:0] shift_2 = {in[5:0], in[7:6]};

    // Shift by 4 positions
    wire [7:0] shift_4 = {in[3:0], in[7:4]};

    // Select the correct output based on the control signal
    assign out = (ctrl[2])? shift_4 : 
                 (ctrl[1])? shift_2 : 
                 (ctrl[0])? shift_1 : in;

endmodule