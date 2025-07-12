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

reg [3:0] enable0, enable1, enable2, enable3, enable4, enable5;

always @(*) begin
    case (sel)
        3'b000: begin enable0 = 4'b1111; enable1 = 4'b0000; enable2 = 4'b0000; enable3 = 4'b0000; enable4 = 4'b0000; enable5 = 4'b0000; end
        3'b001: begin enable0 = 4'b0000; enable1 = 4'b1111; enable2 = 4'b0000; enable3 = 4'b0000; enable4 = 4'b0000; enable5 = 4'b0000; end
        3'b010: begin enable0 = 4'b0000; enable1 = 4'b0000; enable2 = 4'b1111; enable3 = 4'b0000; enable4 = 4'b0000; enable5 = 4'b0000; end
        3'b011: begin enable0 = 4'b0000; enable1 = 4'b0000; enable2 = 4'b0000; enable3 = 4'b1111; enable4 = 4'b0000; enable5 = 4'b0000; end
        3'b100: begin enable0 = 4'b0000; enable1 = 4'b0000; enable2 = 4'b0000; enable3 = 4'b0000; enable4 = 4'b1111; enable5 = 4'b0000; end
        3'b101: begin enable0 = 4'b0000; enable1 = 4'b0000; enable2 = 4'b0000; enable3 = 4'b0000; enable4 = 4'b0000; enable5 = 4'b1111; end
        default: begin enable0 = 4'b0000; enable1 = 4'b0000; enable2 = 4'b0000; enable3 = 4'b0000; enable4 = 4'b0000; enable5 = 4'b0000; end
    endcase
end

always @(*) begin
    out = (enable0 & data0) | (enable1 & data1) | (enable2 & data2) | (enable3 & data3) | (enable4 & data4) | (enable5 & data5);
end

endmodule