module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// First level: 4:1 mux based on cd
wire [3:0] mux_in;

// Each mux input implements the ab pattern for that cd case
assign mux_in[0] = ~a | ~b;       // cd=00: out=1 except ab=11
assign mux_in[1] = (~a & ~b) | (~a & b) | (a & ~b); // cd=01: out=1 except ab=01 and ab=11
assign mux_in[2] = (~a & b) | (a & ~b) | (a & b);   // cd=11: out=1 except ab=00
assign mux_in[3] = (~a & ~b) | (~a & b);            // cd=10: out=1 except ab=11 and ab=10

// Final mux selection
assign out = (c & d) ? mux_in[2] : 
             (c & ~d) ? mux_in[3] :
             (~c & d) ? mux_in[1] : mux_in[0];

endmodule