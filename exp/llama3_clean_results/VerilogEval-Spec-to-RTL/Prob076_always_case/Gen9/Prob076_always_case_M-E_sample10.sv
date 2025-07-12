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

reg [3:0] data[6];

always @(*) begin
    data[0] = data0;
    data[1] = data1;
    data[2] = data2;
    data[3] = data3;
    data[4] = data4;
    data[5] = data5;
    
    if (sel >= 6) begin
        out = 4'd0;
    end else begin
        out = data[sel];
    end
end

endmodule