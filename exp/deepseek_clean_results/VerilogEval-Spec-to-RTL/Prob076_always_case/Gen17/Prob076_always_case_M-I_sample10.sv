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
    if (sel > 3'b101) begin
        out = 4'b0;
    end else if (sel == 3'b000) begin
        out = data0;
    end else if (sel == 3'b001) begin
        out = data1;
    end else if (sel == 3'b010) begin
        out = data2;
    end else if (sel == 3'b011) begin
        out = data3;
    end else if (sel == 3'b100) begin
        out = data4;
    end else begin // sel == 3'b101
        out = data5;
    end
end

endmodule