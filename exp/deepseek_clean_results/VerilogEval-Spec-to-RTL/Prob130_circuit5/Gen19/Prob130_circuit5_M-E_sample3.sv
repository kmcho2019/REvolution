module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early termination check for 'f' output
wire output_f = |c[3:2];

// 4:1 mux for valid selection cases
wire [3:0] mux_out = 
    (c[1:0] == 2'b00) ? b :
    (c[1:0] == 2'b01) ? e :
    (c[1:0] == 2'b10) ? a :
    d;  // default case when c[1:0] == 2'b11

// Final output selection
assign q = output_f ? 4'b1111 : mux_out;

endmodule