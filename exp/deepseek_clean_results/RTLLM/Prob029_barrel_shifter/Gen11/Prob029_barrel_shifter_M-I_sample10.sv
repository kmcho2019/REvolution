module barrel_shifter(
    input [7:0] in,        // Input data to be rotated
    input [2:0] ctrl,      // Control bits: ctrl[2]=4bit, ctrl[1]=2bit, ctrl[0]=1bit
    output [7:0] out       // Rotated output (right rotation)
);

// Single assignment with nested conditionals for optimal PPA
// Performs right rotation by 4, 2, then 1 bits based on ctrl signals
assign out = ctrl[0] ? 
                (ctrl[1] ? 
                    (ctrl[2] ? {in[0], in[7:1]} : {in[1:0], in[7:2]}) : 
                    (ctrl[2] ? {in[3:0], in[7:4]} : {in[0], in[7:1]})) :
                (ctrl[1] ? 
                    (ctrl[2] ? {in[5:0], in[7:6]} : {in[1:0], in[7:2]}) : 
                    (ctrl[2] ? {in[3:0], in[7:4]} : in));

endmodule