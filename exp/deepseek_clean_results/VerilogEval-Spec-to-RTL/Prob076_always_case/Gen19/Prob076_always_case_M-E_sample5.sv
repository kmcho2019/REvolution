module TopModule (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [3:0] out
);

// Generate enable signals for each data input
wire en0 = (sel == 3'd0);
wire en1 = (sel == 3'd1);
wire en2 = (sel == 3'd2);
wire en3 = (sel == 3'd3);
wire en4 = (sel == 3'd4);
wire en5 = (sel == 3'd5);

// Bitwise OR of all enabled data inputs
assign out = (data0 & {4{en0}}) | 
             (data1 & {4{en1}}) | 
             (data2 & {4{en2}}) | 
             (data3 & {4{en3}}) | 
             (data4 & {4{en4}}) | 
             (data5 & {4{en5}});

endmodule