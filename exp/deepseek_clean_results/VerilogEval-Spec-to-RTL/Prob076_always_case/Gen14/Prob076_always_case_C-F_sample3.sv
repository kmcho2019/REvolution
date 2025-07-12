module TopModule (
    input [2:0] sel,
    input [3:0] data0, data1, data2, data3, data4, data5,
    output reg [3:0] out
);

always @(*) begin
    case (sel)
        3'd0: out = data0;
        3'd1: out = data1;
        3'd2: out = data2;
        3'd3: out = data3;
        3'd4: out = data4;
        3'd5: out = data5;
        default: out = 4'b0;  // Covers all other cases (6-7)
    endcase
end

endmodule