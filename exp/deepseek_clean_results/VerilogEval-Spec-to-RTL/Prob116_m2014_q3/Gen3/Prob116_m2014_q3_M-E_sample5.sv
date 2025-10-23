module TopModule(
    input [3:0] x,  // x[3:0] represents x[4],x[3],x[2],x[1] respectively
    output reg f
);
    always @(*) begin
        case ({x[3], x[2], x[1], x[0]})  // x[4],x[3],x[2],x[1]
            // x[4]x[3] = 00
            4'b00_00: f = 1'bx;  // d
            4'b00_01: f = 1'b0;
            4'b00_11: f = 1'bx;   // d
            4'b00_10: f = 1'bx;   // d
            
            // x[4]x[3] = 01
            4'b01_00: f = 1'b0;
            4'b01_01: f = 1'bx;   // d
            4'b01_11: f = 1'b1;
            4'b01_10: f = 1'b0;
            
            // x[4]x[3] = 11
            4'b11_00: f = 1'b1;
            4'b11_01: f = 1'b1;
            4'b11_11: f = 1'bx;   // d
            4'b11_10: f = 1'bx;   // d
            
            // x[4]x[3] = 10
            4'b10_00: f = 1'b1;
            4'b10_01: f = 1'b1;
            4'b10_11: f = 1'b0;
            4'b10_10: f = 1'bx;   // d
            
            default: f = 1'bx;
        endcase
    end
endmodule