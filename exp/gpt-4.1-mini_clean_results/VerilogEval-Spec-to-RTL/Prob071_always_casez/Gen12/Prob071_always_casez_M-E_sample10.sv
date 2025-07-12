module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    wire left_set = |in[3:0];  // Check lower nibble
    wire right_set = |in[7:4]; // Check upper nibble

    wire [1:0] lower_pos;
    wire [1:0] upper_pos;

    // 4-bit priority encoder for lower nibble
    assign lower_pos = (in[0]) ? 2'd0 :
                       (in[1]) ? 2'd1 :
                       (in[2]) ? 2'd2 :
                       (in[3]) ? 2'd3 : 2'd0;

    // 4-bit priority encoder for upper nibble
    assign upper_pos = (in[4]) ? 2'd0 :
                       (in[5]) ? 2'd1 :
                       (in[6]) ? 2'd2 :
                       (in[7]) ? 2'd3 : 2'd0;

    // If lower nibble has any bit set, output its position.
    // Otherwise, output upper nibble position plus 4.
    assign pos = left_set ? {1'b0, lower_pos} :
                           {1'b1, upper_pos};

endmodule