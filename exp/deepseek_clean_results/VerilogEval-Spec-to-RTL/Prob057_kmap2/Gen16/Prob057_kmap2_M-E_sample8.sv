module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// 4:1 MUX with ab as select lines
wire [1:0] sel = {a, b};
wire [3:0] mux_in;

// Mux inputs for each ab case
assign mux_in[0] = ~(c & d);       // ab=00: out=1 unless cd=11
assign mux_in[1] = ~c | d;         // ab=01: out=1 when cd=00 or 10
assign mux_in[2] = c | d;          // ab=11: out=1 unless cd=00
assign mux_in[3] = ~(c ^ d);       // ab=10: out=1 when cd=00 or 01

// Final mux implementation
assign out = mux_in[sel];

endmodule