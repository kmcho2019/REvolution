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
    reg [3:0] temp_out;
    temp_out = 4'b0000;
    
    if (sel == 3'b000) temp_out = data0;
    else if (sel == 3'b001) temp_out = data1;
    else if (sel == 3'b010) temp_out = data2;
    else if (sel == 3'b011) temp_out = data3;
    else if (sel == 3'b100) temp_out = data4;
    else if (sel == 3'b101) temp_out = data5;
    
    out = temp_out;
end

endmodule