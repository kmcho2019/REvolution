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

// Enable signals for each data input
wire enable0, enable1, enable2, enable3, enable4, enable5;

// 3-to-6 binary decoder
assign enable0 = (sel == 3'b000);
assign enable1 = (sel == 3'b001);
assign enable2 = (sel == 3'b010);
assign enable3 = (sel == 3'b011);
assign enable4 = (sel == 3'b100);
assign enable5 = (sel == 3'b101);

// Data selection using enable signals
assign out = (enable0 ? data0 : 4'b0000) |
             (enable1 ? data1 : 4'b0000) |
             (enable2 ? data2 : 4'b0000) |
             (enable3 ? data3 : 4'b0000) |
             (enable4 ? data4 : 4'b0000) |
             (enable5 ? data5 : 4'b0000);

endmodule