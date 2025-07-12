module TopModule (
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

wire [23:0] all_data;
assign all_data = {data5, data4, data3, data2, data1, data0};

always @(*) begin
    if (sel <= 3'd5)
        out = all_data >> (sel * 4);
    else
        out = 4'b0000;
end

endmodule