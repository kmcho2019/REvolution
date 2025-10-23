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

// Decoding the select signal
wire enable0 = (sel == 3'b000);
wire enable1 = (sel == 3'b001);
wire enable2 = (sel == 3'b010);
wire enable3 = (sel == 3'b011);
wire enable4 = (sel == 3'b100);
wire enable5 = (sel == 3'b101);

// Gating the data inputs
wire [3:0] gated_data0 = enable0 ? data0 : 4'b0000;
wire [3:0] gated_data1 = enable1 ? data1 : 4'b0000;
wire [3:0] gated_data2 = enable2 ? data2 : 4'b0000;
wire [3:0] gated_data3 = enable3 ? data3 : 4'b0000;
wire [3:0] gated_data4 = enable4 ? data4 : 4'b0000;
wire [3:0] gated_data5 = enable5 ? data5 : 4'b0000;

// Combining the gated data inputs
assign out = gated_data0 | gated_data1 | gated_data2 | gated_data3 | gated_data4 | gated_data5;

endmodule