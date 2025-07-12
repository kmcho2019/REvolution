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

reg [3:0] en0, en1, en2, en3, en4, en5;

always @(*) begin
    // Create enable signals for each data input
    en0 = (sel == 3'b000) ? 4'b1111 : 4'b0000;
    en1 = (sel == 3'b001) ? 4'b1111 : 4'b0000;
    en2 = (sel == 3'b010) ? 4'b1111 : 4'b0000;
    en3 = (sel == 3'b011) ? 4'b1111 : 4'b0000;
    en4 = (sel == 3'b100) ? 4'b1111 : 4'b0000;
    en5 = (sel == 3'b101) ? 4'b1111 : 4'b0000;

    // Select the correct data input based on the enable signals
    out = (en0 & data0) | (en1 & data1) | (en2 & data2) | (en3 & data3) | (en4 & data4) | (en5 & data5);
end

endmodule