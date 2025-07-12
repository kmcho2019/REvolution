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
    reg [3:0] temp;
    temp = 4'b0000;
    
    if (sel == 3'b000) temp = data0;
    else if (sel == 3'b001) temp = data1;
    else if (sel == 3'b010) temp = data2;
    else if (sel == 3'b011) temp = data3;
    else if (sel == 3'b100) temp = data4;
    else if (sel == 3'b101) temp = data5;
    
    out = temp;
end

endmodule