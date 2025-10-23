module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

wire [3:0] masked; 
assign masked = in;

// Priority encoding from MSB to LSB using combinational conditional expressions
assign pos = (masked[3]) ? 2'd3 :
             (masked[2]) ? 2'd2 :
             (masked[1]) ? 2'd1 :
             (masked[0]) ? 2'd0 :
             2'd0;

endmodule