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
    case (sel)
        3'b000: out = data0;  // Case 0
        3'b001: out = data1;  // Case 1
        3'b010: out = data2;  // Case 2
        3'b011: out = data3;  // Case 3
        3'b100: out = data4;  // Case 4
        3'b101: out = data5;  // Case 5
        default: out = 4'b0000; // Cases 6-7 (invalid)
    endcase
end

endmodule