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

reg [3:0] mid0, mid1, mid2;

always @(sel or data0 or data1 or data2 or data3 or data4 or data5) begin
    // Level 1
    mid0 = (sel[0] == 0) ? data0 : data1;
    mid1 = (sel[0] == 0) ? data2 : data3;
    mid2 = (sel[0] == 0) ? data4 : data5;
    
    // Level 2
    out = (sel[1] == 0) ? (sel[0] == 0) ? mid0 : mid1 : mid2;
    if (sel >= 3'b110) begin
        out = 4'b0000;
    end
end

endmodule