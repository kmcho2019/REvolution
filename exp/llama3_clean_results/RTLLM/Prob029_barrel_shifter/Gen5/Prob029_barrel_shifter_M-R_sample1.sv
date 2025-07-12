module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Directly implement the shifting logic using bitwise operations
    assign out[0] = (ctrl[2] ? in[4] : (ctrl[1] ? in[6] : (ctrl[0] ? in[7] : in[0])));
    assign out[1] = (ctrl[2] ? in[5] : (ctrl[1] ? in[7] : (ctrl[0] ? in[0] : in[1])));
    assign out[2] = (ctrl[2] ? in[6] : (ctrl[1] ? in[0] : (ctrl[0] ? in[1] : in[2])));
    assign out[3] = (ctrl[2] ? in[7] : (ctrl[1] ? in[1] : (ctrl[0] ? in[2] : in[3])));
    assign out[4] = (ctrl[2] ? in[0] : (ctrl[1] ? in[2] : (ctrl[0] ? in[3] : in[4])));
    assign out[5] = (ctrl[2] ? in[1] : (ctrl[1] ? in[3] : (ctrl[0] ? in[4] : in[5])));
    assign out[6] = (ctrl[2] ? in[2] : (ctrl[1] ? in[4] : (ctrl[0] ? in[5] : in[6])));
    assign out[7] = (ctrl[2] ? in[3] : (ctrl[1] ? in[5] : (ctrl[0] ? in[6] : in[7])));

endmodule