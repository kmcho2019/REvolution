module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early check for invalid selection (c >=4)
wire invalid_sel = |c[3:2];

// Efficient 4:1 mux using bitwise operations
wire [3:0] mux_out = 
    (c[1:0] == 2'b00) ? b :
    (c[1:0] == 2'b01) ? e :
    (c[1:0] == 2'b10) ? a :
    d;

// Output is mux_out unless invalid_sel, then output 'f'
assign q = invalid_sel ? 4'b1111 : mux_out;

endmodule