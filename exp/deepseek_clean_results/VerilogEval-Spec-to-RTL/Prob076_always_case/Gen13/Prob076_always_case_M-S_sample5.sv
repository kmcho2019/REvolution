module TopModule (
    input [2:0] sel,
    input [3:0] data0, data1, data2, data3, data4, data5,
    output reg [3:0] out
);

always @(*) case(sel)
    0: out = data0;
    1: out = data1;
    2: out = data2;
    3: out = data3;
    4: out = data4;
    5: out = data5;
    default: out = 0;
endcase

endmodule