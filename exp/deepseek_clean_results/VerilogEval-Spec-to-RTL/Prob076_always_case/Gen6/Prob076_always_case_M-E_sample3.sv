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

// Generate selection signals
wire sel0 = (sel == 3'b000);
wire sel1 = (sel == 3'b001);
wire sel2 = (sel == 3'b010);
wire sel3 = (sel == 3'b011);
wire sel4 = (sel == 3'b100);
wire sel5 = (sel == 3'b101);

// Bitwise parallel multiplexing
assign out = (data0 & {4{sel0}}) | 
             (data1 & {4{sel1}}) |
             (data2 & {4{sel2}}) |
             (data3 & {4{sel3}}) |
             (data4 & {4{sel4}}) |
             (data5 & {4{sel5}});

endmodule