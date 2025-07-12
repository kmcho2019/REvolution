module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Single continuous assignment implementing all shift stages
    assign out = ctrl[0] ? { (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[0] , 
                             (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[7:1] } 
                           : (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[1:0] , 
                             (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in)[7:2] } 
                           : (ctrl[1] ? { (ctrl[2] ? {in[3:0], in[7:4]} : in) 
                           : (ctrl[2] ? {in[3:0], in[7:4]} : in));
endmodule