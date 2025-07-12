module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Priority encoder implementation
wire [3:0] selected_output;
assign selected_output = 
    (c[1:0] == 2'b00) ? b :  // Highest priority
    (c[1:0] == 2'b01) ? e :
    (c[1:0] == 2'b10) ? a :
    (c[1:0] == 2'b11) ? d : 4'b1111;

// Output is either selected value or 'f' if c > 3
assign q = (|c[3:2]) ? 4'b1111 : selected_output;

endmodule