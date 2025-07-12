module TopModule (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);

always @(*) begin
    case (sel)
        0: out = data0;  // sel = 3'b000
        1: out = data1;  // sel = 3'b001
        2: out = data2;  // sel = 3'b010
        3: out = data3;  // sel = 3'b011
        4: out = data4;  // sel = 3'b100
        5: out = data5;  // sel = 3'b101
        default: out = 4'b0000; // sel = 3'b110 or 3'b111
    endcase
end

endmodule