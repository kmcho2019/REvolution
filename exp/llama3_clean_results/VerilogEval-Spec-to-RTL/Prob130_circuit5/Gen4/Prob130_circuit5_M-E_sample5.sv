module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

// Decoder to generate enable signals based on c
wire en_b = (c == 4'b0000);
wire en_e = (c == 4'b0001);
wire en_a = (c == 4'b0010);
wire en_d = (c == 4'b0011);

// Multiplexer to select the output based on enable signals
assign q = (en_b)? b :
           (en_e)? e :
           (en_a)? a :
           (en_d)? d : 4'b1111;

endmodule