module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Detect when c >= 4 (using OR of upper bits)
wire c_ge4 = |c[3:2];

// 4:1 mux for the special cases
wire [3:0] mux_out = (c[1:0] == 2'b00) ? b :
                     (c[1:0] == 2'b01) ? e :
                     (c[1:0] == 2'b10) ? a :
                     d;

// Final output - select between mux output and 'f' (4'b1111)
assign q = c_ge4 ? 4'b1111 : mux_out;

endmodule