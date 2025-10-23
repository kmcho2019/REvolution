module TopModule(
    input [3:0] x,
    output reg f
);

// The condition for f being high is when x[3] is high or 
// (x[3] is low and x[2] is high and x[1] is high) or 
// (x[3] is low and x[2] is high and x[1] is low). 
// However, considering the map again, it simplifies to:
// f is high when x[3] is high or when x[2] is high.
assign f = (x[3]) | (x[2]);

endmodule