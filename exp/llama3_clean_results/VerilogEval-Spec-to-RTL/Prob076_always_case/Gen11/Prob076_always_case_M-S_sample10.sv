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

wire [3:0] data[6:0] = '{data0, data1, data2, data3, data4, data5, 4'b0};

always @(*) begin
    if (sel >= 6) begin
        out = 4'b0;
    end else begin
        out = data[sel];
    end
end

endmodule