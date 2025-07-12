module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early detection of 'f' case
wire output_f = |c[3:2];

// 2-to-4 decoder for selection logic
wire sel_b = ~c[1] & ~c[0] & ~output_f;
wire sel_e = ~c[1] &  c[0] & ~output_f;
wire sel_a =  c[1] & ~c[0] & ~output_f;
wire sel_d =  c[1] &  c[0] & ~output_f;

// 4:1 multiplexer implementation
assign q = output_f ? 4'b1111 :
           sel_b ? b :
           sel_e ? e :
           sel_a ? a :
           d;  // sel_d case

endmodule