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

// Decoder logic to generate enable signals
wire enable0 = (sel == 3'b000);
wire enable1 = (sel == 3'b001);
wire enable2 = (sel == 3'b010);
wire enable3 = (sel == 3'b011);
wire enable4 = (sel == 3'b100);
wire enable5 = (sel == 3'b101);

// AND gates to gate each data input with its enable signal
wire [3:0] and_out0 = enable0? data0 : 4'b0;
wire [3:0] and_out1 = enable1? data1 : 4'b0;
wire [3:0] and_out2 = enable2? data2 : 4'b0;
wire [3:0] and_out3 = enable3? data3 : 4'b0;
wire [3:0] and_out4 = enable4? data4 : 4'b0;
wire [3:0] and_out5 = enable5? data5 : 4'b0;

// OR gates to combine the outputs of the AND gates
assign out[0] = and_out0[0] | and_out1[0] | and_out2[0] | and_out3[0] | and_out4[0] | and_out5[0];
assign out[1] = and_out0[1] | and_out1[1] | and_out2[1] | and_out3[1] | and_out4[1] | and_out5[1];
assign out[2] = and_out0[2] | and_out1[2] | and_out2[2] | and_out3[2] | and_out4[2] | and_out5[2];
assign out[3] = and_out0[3] | and_out1[3] | and_out2[3] | and_out3[3] | and_out4[3] | and_out5[3];

endmodule