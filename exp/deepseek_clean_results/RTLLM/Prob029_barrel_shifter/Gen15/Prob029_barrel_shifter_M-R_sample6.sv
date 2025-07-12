module barrel_shifter(
    input [7:0] in,        // 8-bit input
    input [2:0] ctrl,      // Control: [2]=4-bit, [1]=2-bit, [0]=1-bit
    output [7:0] out       // Rotated output
);

    // Combined single-assignment implementation
    assign out = ctrl[0] ? { (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[1:0], 
                                               (ctrl[2] ? {in[3:0], in[7:4]} : in)[7:2] } 
                                     : (ctrl[2] ? {in[3:0], in[7:4]} : in))[0], 
                            (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[1:0], 
                                               (ctrl[2] ? {in[3:0], in[7:4]} : in)[7:2] } 
                                     : (ctrl[2] ? {in[3:0], in[7:4]} : in))[7:1] } 
                 : (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[1:0], 
                                    (ctrl[2] ? {in[3:0], in[7:4]} : in)[7:2] } 
                          : (ctrl[2] ? {in[3:0], in[7:4]} : in));

endmodule