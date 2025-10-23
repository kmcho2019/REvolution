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

wire sel0 = (sel == 3'b000);
wire sel1 = (sel == 3'b001);
wire sel2 = (sel == 3'b010);
wire sel3 = (sel == 3'b011);
wire sel4 = (sel == 3'b100);
wire sel5 = (sel == 3'b101);
wire valid_sel = (sel <= 3'b101);

wire [3:0] selected_data = 
    ({4{sel0}} & data0) |
    ({4{sel1}} & data1) |
    ({4{sel2}} & data2) |
    ({4{sel3}} & data3) |
    ({4{sel4}} & data4) |
    ({4{sel5}} & data5);

assign out = valid_sel ? selected_data : 4'b0000;

endmodule