module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

wire [5:0] enable;

// Decoder to generate enable signals
always @(sel) begin
    case(sel)
        3'b000: enable = 6'b000001;
        3'b001: enable = 6'b000010;
        3'b010: enable = 6'b000100;
        3'b011: enable = 6'b001000;
        3'b100: enable = 6'b010000;
        3'b101: enable = 6'b100000;
        default: enable = 6'b000000;
    endcase
end

// Select the correct data input based on the enable signals
assign out = (enable[0] ? data0 : 4'b0000) | 
             (enable[1] ? {4{(enable[1])}, data1[0]} : 4'b0000) | 
             (enable[2] ? {4{(enable[2])}, data2[0]} : 4'b0000) | 
             (enable[3] ? {4{(enable[3])}, data3[0]} : 4'b0000) | 
             (enable[4] ? {4{(enable[4])}, data4[0]} : 4'b0000) | 
             (enable[5] ? {4{(enable[5])}, data5[0]} : 4'b0000);

endmodule