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

reg [5:0] enable;

always @(*) begin
    enable = 6'b000000; // Reset enable signals
    case (sel)
        3'b000: enable[0] = 1'b1;
        3'b001: enable[1] = 1'b1;
        3'b010: enable[2] = 1'b1;
        3'b011: enable[3] = 1'b1;
        3'b100: enable[4] = 1'b1;
        3'b101: enable[5] = 1'b1;
    endcase
    
    // Use enable signals to select data
    out = (enable[0] ? data0 : 4'b0000) | 
           (enable[1] ? data1 : 4'b0000) | 
           (enable[2] ? data2 : 4'b0000) | 
           (enable[3] ? data3 : 4'b0000) | 
           (enable[4] ? data4 : 4'b0000) | 
           (enable[5] ? data5 : 4'b0000);
end

endmodule