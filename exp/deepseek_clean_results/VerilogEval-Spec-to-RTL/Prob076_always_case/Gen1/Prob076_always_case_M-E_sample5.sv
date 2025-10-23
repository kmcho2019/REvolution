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

wire [3:0] stage0_out0, stage0_out1, stage0_out2;
wire [3:0] stage1_out0, stage1_out1;
wire valid_sel;

// First stage: 2-to-1 muxes using sel[0]
assign stage0_out0 = sel[0] ? data1 : data0;
assign stage0_out1 = sel[0] ? data3 : data2;
assign stage0_out2 = sel[0] ? data5 : data4;

// Second stage: 2-to-1 muxes using sel[1]
assign stage1_out0 = sel[1] ? stage0_out1 : stage0_out0;
assign stage1_out1 = sel[1] ? 4'b0 : stage0_out2;  // Only 3 inputs at this level

// Final stage: 2-to-1 mux using sel[2]
wire [3:0] mux_out = sel[2] ? 4'b0 : stage1_out1;

// Validity check (sel < 6)
assign valid_sel = ~sel[2] | ~sel[1] | ~sel[0];

// Output is mux result when valid, else 0
assign out = valid_sel ? mux_out : 4'b0;

endmodule