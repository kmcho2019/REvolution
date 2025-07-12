module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    // 4:1 mux with x[3:2] as selector
    assign f = (x[3:2] == 2'b00) ? (x[1] & ~x[0]) :  // For x[3]x[4]=00, output 0 unless x[1]x[2]=01
               (x[3:2] == 2'b01) ? (~x[0] | (x[1] & x[0])) :  // For x[3]x[4]=01, simplified logic
               (x[3:2] == 2'b10) ? (~x[1] | x[0]) :  // For x[3]x[4]=10, mostly 1 except when x[1]x[2]=10
               1'b1;  // Default case for x[3]x[4]=11 (mostly 1)
endmodule