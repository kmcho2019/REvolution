module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Each output bit is selected from input based on rotation amount
    assign out[0] = (ctrl == 3'b000) ? in[0] :
                   (ctrl == 3'b001) ? in[7] :
                   (ctrl == 3'b010) ? in[6] :
                   (ctrl == 3'b011) ? in[5] :
                   (ctrl == 3'b100) ? in[4] :
                   (ctrl == 3'b101) ? in[3] :
                   (ctrl == 3'b110) ? in[2] :
                   in[1];

    assign out[1] = (ctrl == 3'b000) ? in[1] :
                   (ctrl == 3'b001) ? in[0] :
                   (ctrl == 3'b010) ? in[7] :
                   (ctrl == 3'b011) ? in[6] :
                   (ctrl == 3'b100) ? in[5] :
                   (ctrl == 3'b101) ? in[4] :
                   (ctrl == 3'b110) ? in[3] :
                   in[2];

    assign out[2] = (ctrl == 3'b000) ? in[2] :
                   (ctrl == 3'b001) ? in[1] :
                   (ctrl == 3'b010) ? in[0] :
                   (ctrl == 3'b011) ? in[7] :
                   (ctrl == 3'b100) ? in[6] :
                   (ctrl == 3'b101) ? in[5] :
                   (ctrl == 3'b110) ? in[4] :
                   in[3];

    assign out[3] = (ctrl == 3'b000) ? in[3] :
                   (ctrl == 3'b001) ? in[2] :
                   (ctrl == 3'b010) ? in[1] :
                   (ctrl == 3'b011) ? in[0] :
                   (ctrl == 3'b100) ? in[7] :
                   (ctrl == 3'b101) ? in[6] :
                   (ctrl == 3'b110) ? in[5] :
                   in[4];

    assign out[4] = (ctrl == 3'b000) ? in[4] :
                   (ctrl == 3'b001) ? in[3] :
                   (ctrl == 3'b010) ? in[2] :
                   (ctrl == 3'b011) ? in[1] :
                   (ctrl == 3'b100) ? in[0] :
                   (ctrl == 3'b101) ? in[7] :
                   (ctrl == 3'b110) ? in[6] :
                   in[5];

    assign out[5] = (ctrl == 3'b000) ? in[5] :
                   (ctrl == 3'b001) ? in[4] :
                   (ctrl == 3'b010) ? in[3] :
                   (ctrl == 3'b011) ? in[2] :
                   (ctrl == 3'b100) ? in[1] :
                   (ctrl == 3'b101) ? in[0] :
                   (ctrl == 3'b110) ? in[7] :
                   in[6];

    assign out[6] = (ctrl == 3'b000) ? in[6] :
                   (ctrl == 3'b001) ? in[5] :
                   (ctrl == 3'b010) ? in[4] :
                   (ctrl == 3'b011) ? in[3] :
                   (ctrl == 3'b100) ? in[2] :
                   (ctrl == 3'b101) ? in[1] :
                   (ctrl == 3'b110) ? in[0] :
                   in[7];

    assign out[7] = (ctrl == 3'b000) ? in[7] :
                   (ctrl == 3'b001) ? in[6] :
                   (ctrl == 3'b010) ? in[5] :
                   (ctrl == 3'b011) ? in[4] :
                   (ctrl == 3'b100) ? in[3] :
                   (ctrl == 3'b101) ? in[2] :
                   (ctrl == 3'b110) ? in[1] :
                   in[0];

endmodule