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

reg [3:0] enable0, enable1, enable2, enable3, enable4, enable5;

always @(*) begin
    // Decode sel into enable signals
    enable0 = (sel == 3'b000)? 4'b1111 : 4'b0000;
    enable1 = (sel == 3'b001)? 4'b1111 : 4'b0000;
    enable2 = (sel == 3'b010)? 4'b1111 : 4'b0000;
    enable3 = (sel == 3'b011)? 4'b1111 : 4'b0000;
    enable4 = (sel == 3'b100)? 4'b1111 : 4'b0000;
    enable5 = (sel == 3'b101)? 4'b1111 : 4'b0000;

    // Select data input based on enable signals
    out = (enable0 & data0) | (enable1 & data1) | (enable2 & data2) | (enable3 & data3) | (enable4 & data4) | (enable5 & data5);
end

endmodule