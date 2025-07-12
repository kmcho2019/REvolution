module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early detection of default case (c > 3)
wire default_case = |c[3:2];

// Direct 4:1 multiplexer using c[1:0] as select
assign q = default_case ? 4'b1111 : 
           (c[1:0] == 2'b00) ? b :
           (c[1:0] == 2'b01) ? e :
           (c[1:0] == 2'b10) ? a : d;

endmodule