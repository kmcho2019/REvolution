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

// Bit 0 mux
assign out[0] = (sel == 3'b000) ? data0[0] :
                (sel == 3'b001) ? data1[0] :
                (sel == 3'b010) ? data2[0] :
                (sel == 3'b011) ? data3[0] :
                (sel == 3'b100) ? data4[0] :
                (sel == 3'b101) ? data5[0] :
                1'b0;

// Bit 1 mux
assign out[1] = (sel == 3'b000) ? data0[1] :
                (sel == 3'b001) ? data1[1] :
                (sel == 3'b010) ? data2[1] :
                (sel == 3'b011) ? data3[1] :
                (sel == 3'b100) ? data4[1] :
                (sel == 3'b101) ? data5[1] :
                1'b0;

// Bit 2 mux
assign out[2] = (sel == 3'b000) ? data0[2] :
                (sel == 3'b001) ? data1[2] :
                (sel == 3'b010) ? data2[2] :
                (sel == 3'b011) ? data3[2] :
                (sel == 3'b100) ? data4[2] :
                (sel == 3'b101) ? data5[2] :
                1'b0;

// Bit 3 mux
assign out[3] = (sel == 3'b000) ? data0[3] :
                (sel == 3'b001) ? data1[3] :
                (sel == 3'b010) ? data2[3] :
                (sel == 3'b011) ? data3[3] :
                (sel == 3'b100) ? data4[3] :
                (sel == 3'b101) ? data5[3] :
                1'b0;

endmodule