module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [3:0] out;
assign out = (c[1:0] == 2'b00) ? b :
             (c[1:0] == 2'b01) ? e :
             (c[1:0] == 2'b10) ? a :
             (c[1:0] == 2'b11) ? d : 4'b0;

assign q = (c[3:2] != 2'b00) ? 4'd15 : out;

endmodule