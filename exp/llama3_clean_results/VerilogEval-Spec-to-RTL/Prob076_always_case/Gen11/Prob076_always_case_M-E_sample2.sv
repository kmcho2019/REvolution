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

reg [3:0] dataArray [5:0];

always @(*) begin
    dataArray[0] = data0;
    dataArray[1] = data1;
    dataArray[2] = data2;
    dataArray[3] = data3;
    dataArray[4] = data4;
    dataArray[5] = data5;
    
    if (sel >= 3'b000 && sel <= 3'b101) begin
        out = dataArray[sel];
    end else begin
        out = 4'b0000;
    end
end

endmodule