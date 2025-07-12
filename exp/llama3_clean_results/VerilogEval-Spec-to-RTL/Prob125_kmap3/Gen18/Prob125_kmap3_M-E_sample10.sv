module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output reg out
);

// Logic for when 'a' is 0
wire out_when_a0;
assign out_when_a0 = (~b & c);

// Logic for when 'a' is 1
wire out_when_a1;
assign out_when_a1 = 1'b1;

// 2-to-1 Multiplexer to select output based on 'a'
assign out = (a) ? out_when_a1 : out_when_a0;

endmodule