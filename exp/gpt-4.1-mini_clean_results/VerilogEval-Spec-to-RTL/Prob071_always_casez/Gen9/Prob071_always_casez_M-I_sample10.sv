module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    wire lower_valid = |in[3:0];
    wire upper_valid = |in[7:4];

    wire [1:0] lower_pos;
    wire [1:0] upper_pos;

    // Priority encoder for lower 4 bits
    assign lower_pos = (in[0] ? 2'd0 :
                        in[1] ? 2'd1 :
                        in[2] ? 2'd2 :
                        in[3] ? 2'd3 : 2'd0);

    // Priority encoder for upper 4 bits
    assign upper_pos = (in[4] ? 2'd0 :
                        in[5] ? 2'd1 :
                        in[6] ? 2'd2 :
                        in[7] ? 2'd3 : 2'd0);

    assign pos = lower_valid ? {1'b0, lower_pos} :
                 upper_valid ? {1'b1, upper_pos} : 3'd0;

endmodule