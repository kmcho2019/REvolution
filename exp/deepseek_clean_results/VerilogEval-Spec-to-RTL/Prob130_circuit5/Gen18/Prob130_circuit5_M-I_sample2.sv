module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

wire out_of_range = (c > 4'd3);
wire [1:0] sel = (out_of_range) ? 2'b11 : c[1:0];

assign q = (sel == 2'b00) ? b :
           (sel == 2'b01) ? e :
           (sel == 2'b10) ? a :
           (sel == 2'b11) ? 4'b1111 : d;

endmodule