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

// One-hot decode of select signal
wire sel0 = (sel == 3'b000);
wire sel1 = (sel == 3'b001);
wire sel2 = (sel == 3'b010);
wire sel3 = (sel == 3'b011);
wire sel4 = (sel == 3'b100);
wire sel5 = (sel == 3'b101);
wire sel_invalid = (sel > 3'b101);

// Mask each data input with its select signal
wire [3:0] masked0 = data0 & {4{sel0}};
wire [3:0] masked1 = data1 & {4{sel1}};
wire [3:0] masked2 = data2 & {4{sel2}};
wire [3:0] masked3 = data3 & {4{sel3}};
wire [3:0] masked4 = data4 & {4{sel4}};
wire [3:0] masked5 = data5 & {4{sel5}};

// Combine all masked inputs and force zero for invalid selects
assign out = sel_invalid ? 4'b0 : 
             (masked0 | masked1 | masked2 | masked3 | masked4 | masked5);

endmodule