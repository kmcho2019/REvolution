module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Each output bit is selected from input bits based on shift amount
    assign out[0] = (ctrl == 3'd0) ? in[0] :
                   (ctrl == 3'd1) ? in[7] :
                   (ctrl == 3'd2) ? in[6] :
                   (ctrl == 3'd3) ? in[5] :
                   (ctrl == 3'd4) ? in[4] :
                   (ctrl == 3'd5) ? in[3] :
                   (ctrl == 3'd6) ? in[2] :
                   in[1];

    assign out[1] = (ctrl == 3'd0) ? in[1] :
                   (ctrl == 3'd1) ? in[0] :
                   (ctrl == 3'd2) ? in[7] :
                   (ctrl == 3'd3) ? in[6] :
                   (ctrl == 3'd4) ? in[5] :
                   (ctrl == 3'd5) ? in[4] :
                   (ctrl == 3'd6) ? in[3] :
                   in[2];

    assign out[2] = (ctrl == 3'd0) ? in[2] :
                   (ctrl == 3'd1) ? in[1] :
                   (ctrl == 3'd2) ? in[0] :
                   (ctrl == 3'd3) ? in[7] :
                   (ctrl == 3'd4) ? in[6] :
                   (ctrl == 3'd5) ? in[5] :
                   (ctrl == 3'd6) ? in[4] :
                   in[3];

    assign out[3] = (ctrl == 3'd0) ? in[3] :
                   (ctrl == 3'd1) ? in[2] :
                   (ctrl == 3'd2) ? in[1] :
                   (ctrl == 3'd3) ? in[0] :
                   (ctrl == 3'd4) ? in[7] :
                   (ctrl == 3'd5) ? in[6] :
                   (ctrl == 3'd6) ? in[5] :
                   in[4];

    assign out[4] = (ctrl == 3'd0) ? in[4] :
                   (ctrl == 3'd1) ? in[3] :
                   (ctrl == 3'd2) ? in[2] :
                   (ctrl == 3'd3) ? in[1] :
                   (ctrl == 3'd4) ? in[0] :
                   (ctrl == 3'd5) ? in[7] :
                   (ctrl == 3'd6) ? in[6] :
                   in[5];

    assign out[5] = (ctrl == 3'd0) ? in[5] :
                   (ctrl == 3'd1) ? in[4] :
                   (ctrl == 3'd2) ? in[3] :
                   (ctrl == 3'd3) ? in[2] :
                   (ctrl == 3'd4) ? in[1] :
                   (ctrl == 3'd5) ? in[0] :
                   (ctrl == 3'd6) ? in[7] :
                   in[6];

    assign out[6] = (ctrl == 3'd0) ? in[6] :
                   (ctrl == 3'd1) ? in[5] :
                   (ctrl == 3'd2) ? in[4] :
                   (ctrl == 3'd3) ? in[3] :
                   (ctrl == 3'd4) ? in[2] :
                   (ctrl == 3'd5) ? in[1] :
                   (ctrl == 3'd6) ? in[0] :
                   in[7];

    assign out[7] = (ctrl == 3'd0) ? in[7] :
                   (ctrl == 3'd1) ? in[6] :
                   (ctrl == 3'd2) ? in[5] :
                   (ctrl == 3'd3) ? in[4] :
                   (ctrl == 3'd4) ? in[3] :
                   (ctrl == 3'd5) ? in[2] :
                   (ctrl == 3'd6) ? in[1] :
                   in[0];
endmodule