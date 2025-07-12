module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

// Binary decoder to generate enable signals
wire en0, en1, en2, en3, en4, en5;
assign en0 = ~sel[2] & ~sel[1] & ~sel[0];
assign en1 = ~sel[2] & ~sel[1] &  sel[0];
assign en2 = ~sel[2] &  sel[1] & ~sel[0];
assign en3 = ~sel[2] &  sel[1] &  sel[0];
assign en4 =  sel[2] & ~sel[1] & ~sel[0];
assign en5 =  sel[2] & ~sel[1] &  sel[0];

// AND each data input with its enable signal
wire [3:0] and0, and1, and2, and3, and4, and5;
assign and0 = data0 & {4{en0}};
assign and1 = data1 & {4{en1}};
assign and2 = data2 & {4{en2}};
assign and3 = data3 & {4{en3}};
assign and4 = data4 & {4{en4}};
assign and5 = data5 & {4{en5}};

// OR the ANDed outputs to get the final output
assign out = and0 | and1 | and2 | and3 | and4 | and5;

endmodule