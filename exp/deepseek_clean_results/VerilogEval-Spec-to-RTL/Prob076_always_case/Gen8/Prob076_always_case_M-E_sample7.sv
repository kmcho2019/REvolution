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

wire sel0 = (sel == 3'd0);
wire sel1 = (sel == 3'd1);
wire sel2 = (sel == 3'd2);
wire sel3 = (sel == 3'd3);
wire sel4 = (sel == 3'd4);
wire sel5 = (sel == 3'd5);
wire valid = (sel <= 3'd5);

wire [3:0] mux_stage0 = (data0 & {4{sel0}}) | 
                       (data1 & {4{sel1}}) |
                       (data2 & {4{sel2}}) |
                       (data3 & {4{sel3}}) |
                       (data4 & {4{sel4}}) |
                       (data5 & {4{sel5}});

assign out = mux_stage0 & {4{valid}};

endmodule