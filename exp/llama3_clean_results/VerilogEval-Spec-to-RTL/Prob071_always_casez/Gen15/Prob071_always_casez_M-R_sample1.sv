module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    assign pos = 
    in[0] ? 3'd0 :
    in[1] ? 3'd1 :
    in[2] ? 3'd2 :
    in[3] ? 3'd3 :
    in[4] ? 3'd4 :
    in[5] ? 3'd5 :
    in[6] ? 3'd6 :
    in[7] ? 3'd7 : 3'd0;

    // Alternatively, using a casex statement (not directly applicable here due to the nature of the inputs)
    // assign pos = 
    // casex (in)
    //     8'b00000001: 3'd0,
    //     8'b00000010: 3'd1,
    //     8'b00000100: 3'd2,
    //     8'b00001000: 3'd3,
    //     8'b00010000: 3'd4,
    //     8'b00100000: 3'd5,
    //     8'b01000000: 3'd6,
    //     8'b10000000: 3'd7,
    //     default: 3'd0;

    // However, the above casex approach is less efficient and more cumbersome for this specific task
    // A more suitable approach would be to maintain the original conditional operator structure for its simplicity and efficiency

endmodule