module TopModule(
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
    reg [3:0] temp_out;
    temp_out = 4'b0000;
    
    temp_out = (sel == 3'b000)? data0 : temp_out;
    temp_out = (sel == 3'b001)? data1 : temp_out;
    temp_out = (sel == 3'b010)? data2 : temp_out;
    temp_out = (sel == 3'b011)? data3 : temp_out;
    temp_out = (sel == 3'b100)? data4 : temp_out;
    temp_out = (sel == 3'b101)? data5 : temp_out;
    
    out = temp_out;
end

endmodule