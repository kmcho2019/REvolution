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
        3'b000: out = data0;  // Explicit binary for clarity
        3'b001: out = data1;
        3'b010: out = data2;
        3'b011: out = data3;
        3'b100: out = data4;
        3'b101: out = data5;
        3'b110: out = 4'b0;   // Explicit handling of case 6
        3'b111: out = 4'b0;   // Explicit handling of case 7
        default: out = 4'b0;  // Safety net (should never be needed)
    endcase
end

endmodule