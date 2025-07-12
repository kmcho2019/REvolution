module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

// Implement f as a 2-to-1 mux controlled by x3:
// When x3=0, f follows x2
// When x3=1, f follows x1
assign f = x3 ? x1 : x2;

endmodule