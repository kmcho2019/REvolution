module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

reg [3:0] mux_out1;
reg [3:0] mux_out2;
reg [3:0] mux_out3;

always @(sel or data0 or data1 or data2 or data3 or data4 or data5) begin
    // First level of multiplexers
    mux_out1 = (sel[0] == 1'b0) ? data0 : data1;
    mux_out2 = (sel[0] == 1'b0) ? data2 : data3;
    mux_out3 = (sel[0] == 1'b0) ? data4 : data5;

    // Second level of multiplexers
    reg [3:0] mux_out4;
    reg [3:0] mux_out5;
    mux_out4 = (sel[1] == 1'b0) ? mux_out1 : mux_out2;
    mux_out5 = (sel[1] == 1'b0) ? mux_out3 : 4'b0000;

    // Third level of multiplexers
    out = (sel[2] == 1'b0) ? mux_out4 : mux_out5;
end

endmodule