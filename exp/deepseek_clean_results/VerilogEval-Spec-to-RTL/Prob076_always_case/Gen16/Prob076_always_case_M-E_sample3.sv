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

// Generate enable signals for each valid selection
wire sel0 = (sel == 3'b000);
wire sel1 = (sel == 3'b001);
wire sel2 = (sel == 3'b010);
wire sel3 = (sel == 3'b011);
wire sel4 = (sel == 3'b100);
wire sel5 = (sel == 3'b101);

// Bitwise OR of all enabled inputs
assign out[0] = (data0[0] & sel0) | (data1[0] & sel1) | (data2[0] & sel2) |
                (data3[0] & sel3) | (data4[0] & sel4) | (data5[0] & sel5);
assign out[1] = (data0[1] & sel0) | (data1[1] & sel1) | (data2[1] & sel2) |
                (data3[1] & sel3) | (data4[1] & sel4) | (data5[1] & sel5);
assign out[2] = (data0[2] & sel0) | (data1[2] & sel1) | (data2[2] & sel2) |
                (data3[2] & sel3) | (data4[2] & sel4) | (data5[2] & sel5);
assign out[3] = (data0[3] & sel0) | (data1[3] & sel1) | (data2[3] & sel2) |
                (data3[3] & sel3) | (data4[3] & sel4) | (data5[3] & sel5);

endmodule