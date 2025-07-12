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

wire [3:0] stage1_out0, stage1_out1, stage1_out2;
wire [3:0] stage2_out;
wire sel_invalid = (sel > 3'b101);

// First stage: 3 pairs of 2-to-1 muxes
assign stage1_out0 = sel[0] ? data1 : data0;
assign stage1_out1 = sel[0] ? data3 : data2;
assign stage1_out2 = sel[0] ? data5 : data4;

// Second stage: 3-to-1 mux
assign stage2_out = (sel[2:1] == 2'b00) ? stage1_out0 :
                    (sel[2:1] == 2'b01) ? stage1_out1 :
                    (sel[2:1] == 2'b10) ? stage1_out2 :
                    4'b0;

// Final output with invalid select handling
assign out = sel_invalid ? 4'b0 : stage2_out;

endmodule