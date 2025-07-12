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

always @(*) begin
    out = 4'b0;
    if (sel == 3'b000) out = data0;
    else if (sel == 3'b001) out = data1;
    else if (sel == 3'b010) out = data2;
    else if (sel == 3'b011) out = data3;
    else if (sel == 3'b100) out = data4;
    else if (sel == 3'b101) out = data5;
end

endmodule