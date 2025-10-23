module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire [3:0] mux_in;

// Mux inputs based on ab combinations
assign mux_in[0] = ~(c & d);       // ab = 00
assign mux_in[1] = c ^ d;          // ab = 01
assign mux_in[2] = c | d;          // ab = 11
assign mux_in[3] = ~d;             // ab = 10

// 4:1 Mux implementation
assign out = (~b & ~a) ? mux_in[0] :
             (~b &  a) ? mux_in[1] :
             ( b &  a) ? mux_in[2] :
             mux_in[3];

endmodule