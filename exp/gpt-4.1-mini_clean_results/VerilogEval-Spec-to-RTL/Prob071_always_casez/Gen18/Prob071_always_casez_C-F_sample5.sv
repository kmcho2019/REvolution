module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    wire [2:0] lower_pos;
    wire [2:0] upper_pos;

    // Encode position within lower nibble (bits 0 to 3)
    assign lower_pos = (in[0]) ? 3'd0 :
                       (in[1]) ? 3'd1 :
                       (in[2]) ? 3'd2 :
                       (in[3]) ? 3'd3 : 3'd0;

    // Encode position within upper nibble (bits 4 to 7)
    assign upper_pos = (in[4]) ? 3'd4 :
                       (in[5]) ? 3'd5 :
                       (in[6]) ? 3'd6 :
                       (in[7]) ? 3'd7 : 3'd0;

    // Output position: select lower nibble if any bit set there, else upper nibble if any bit set there, else zero
    assign pos = (|in[3:0]) ? lower_pos :
                 (|in[7:4]) ? upper_pos :
                 3'd0;

endmodule