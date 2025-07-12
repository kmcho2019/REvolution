module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [1:0] c_low = c[1:0];
wire c_less_4 = (c < 4);

assign q = c_less_4 ? 
           (c_low == 2'd0 ? b :
            c_low == 2'd1 ? e :
            c_low == 2'd2 ? a :
                            d ) 
           : 4'hF;

endmodule