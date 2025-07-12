module barrel_shifter(
    input [7:0] in, 
    input [2:0] ctrl, 
    output [7:0] out
);

    // Apply shifts sequentially based on control signal
    assign out = (ctrl[2])? (ctrl[1])? (ctrl[0])? {in[7:4], in[3:1], in[0], in[7]} : {in[7:4], in[3:0], in[7]} 
                              : (ctrl[0])? {in[3:0], in[7:4], in[7]} : {in[3:0], in[7:4]}
               : (ctrl[1])? (ctrl[0])? {in[6:0], in[7], in[6]} : {in[6:0], in[7]}
               : (ctrl[0])? {in[7:1], in[0]} : in;

endmodule