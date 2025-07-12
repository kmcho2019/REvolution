module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    assign out = ctrl[0] ? { (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[5:0], 
                                               (ctrl[2] ? {in[3:0], in[7:4]} : in)[7:6] } 
                                   : (ctrl[2] ? {in[3:0], in[7:4]} : in))[6:0], 
                          (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[5:0], 
                                               (ctrl[2] ? {in[3:0], in[7:4]} : in)[7:6] } 
                                   : (ctrl[2] ? {in[3:0], in[7:4]} : in))[7] }
                : (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[5:0], 
                                     (ctrl[2] ? {in[3:0], in[7:4]} : in)[7:6] } 
                         : (ctrl[2] ? {in[3:0], in[7:4]} : in);
endmodule