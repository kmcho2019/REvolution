module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire lower_nonzero = |in[1:0];
wire upper_nonzero = |in[3:2];

assign pos = lower_nonzero ? 
                (in[0] ? 2'b00 : 2'b01) :
             upper_nonzero ?
                (in[2] ? 2'b10 : 2'b11) :
             2'b00;  // default when all zeros

endmodule