module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

wire default_case = (c > 4'b0011);
wire [1:0] sel = c[1:0];

assign q = default_case ? 4'b1111 : 
           (sel == 2'b00) ? b :
           (sel == 2'b01) ? e :
           (sel == 2'b10) ? a :
                            d;

endmodule