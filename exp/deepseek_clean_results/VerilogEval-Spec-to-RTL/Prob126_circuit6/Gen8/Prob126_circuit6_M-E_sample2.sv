module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] even_out, odd_out;

// Even input pattern
assign even_out = ({a, 13'b0} >> 1) ^ {4'b0, a, 9'b0} ^ 
                 ((a == 3'd0) ? 16'h1232 :
                  (a == 3'd2) ? 16'h27d4 :
                  (a == 3'd4) ? 16'h2066 :
                                 16'hc526);

// Odd input pattern                 
assign odd_out = {a, 13'b0} ^ {3'b0, a, 9'b0} ^
                ((a == 3'd1) ? 16'haee0 :
                 (a == 3'd3) ? 16'h5a0e :
                 (a == 3'd5) ? 16'h64ce :
                                16'h2f19);

// Select between even and odd patterns
assign q = a[0] ? odd_out : even_out;

endmodule