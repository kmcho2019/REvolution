module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

// Select lines (constant)
wire sel_hi = 1'b1;  // select upper byte
wire sel_lo = 1'b0;  // select lower byte

// Multiplexer for out_hi
assign out_hi = sel_hi ? in[15:8] : in[7:0];

// Multiplexer for out_lo
assign out_lo = sel_lo ? in[15:8] : in[7:0];

endmodule