module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

// According to the problem statement:
// mux_in[0] corresponds to ab=00
// mux_in[1] corresponds to ab=01
// mux_in[2] corresponds to ab=11
// mux_in[3] corresponds to ab=10

// Extracting from the K-map (for fixed ab, cd varies):
// ab=00 (mux_in[0]) cd=00->0,01->1,11->1,10->1
// ab=01 (mux_in[1]) cd=00->0,01->0,11->0,10->0
// ab=11 (mux_in[2]) cd=00->0,01->0,11->1,10->0
// ab=10 (mux_in[3]) cd=00->1,01->0,11->1,10->1

// Implement mux_in[0] = F for ab=00:
// cd: 00 01 11 10
//    0  1  1  1
// Let's write mux_in[0] as a function of c,d:
// c d | out
// 0 0 |0
// 0 1 |1
// 1 1 |1
// 1 0 |1
// Observing:
// If c=0 and d=0 -> 0
// else 1
// mux_in[0] = c OR d

wire mux0;
assign mux0 = c | d;

// mux_in[1] for ab=01:
// all zeros
assign mux_in[1] = 0;

// mux_in[2] for ab=11:
// cd:
// 00->0
// 01->0
// 11->1
// 10->0
// truth table:
// c d | out
// 0 0 |0
// 0 1 |0
// 1 1 |1
// 1 0 |0
// This is c AND d
wire mux2;
assign mux2 = c & d;

// mux_in[3] for ab=10:
// cd:
// 00->1
// 01->0
// 11->1
// 10->1
// truth table:
// c d | out
// 0 0 |1
// 0 1 |0
// 1 1 |1
// 1 0 |1
// Expression:
// out = (~c & ~d) | (c & d) | (c & ~d)
//    = (~c & ~d) | c
// Because (c&d) + (c&~d) = c(d + ~d) = c * 1 = c
// So out = c + (~c & ~d)
// Let's implement this with 2-to-1 muxes only:

// out = c + (~c & ~d) = (~c & ~d) OR c
// OR implemented as a mux:
// out = mux controlled by c:
// if c=1 => out=1
// if c=0 => out= ~d

// Implement ~d via mux with input d:
// Since no logic gates allowed except multiplexers, implement NOT by mux:
// NOT d = mux with select d, inputs 1 and 0 => if d=0 output=1 else 0

// So, for ~d:

wire not_d;
assign not_d = d ? 1'b0 : 1'b1; // NOT gate implemented as mux

// out mux_in[3]:
// if c==1, output 1
// else output not_d

wire mux3;
assign mux3 = c ? 1'b1 : not_d;

assign mux_in[0] = mux0;
assign mux_in[2] = mux2;
assign mux_in[3] = mux3;

endmodule