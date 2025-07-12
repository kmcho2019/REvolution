module TopModule(
    input [3:0] x,  // x[3]x[4]x[1]x[2] mapping
    output reg f
);
    always @(*) begin
        case ({x[3], x[2], x[1], x[0]})  // x[3]x[4]x[1]x[2]
            // Row 00 (x[3]x[4] = 00)
            4'b00_00: f = 1'bx;  // don't care
            4'b00_01: f = 0;     // mandatory 0
            4'b00_11: f = 1'bx;  // don't care
            4'b00_10: f = 1'bx;  // don't care
            
            // Row 01 (x[3]x[4] = 01)
            4'b01_00: f = 0;     // mandatory 0
            4'b01_01: f = 1'bx;  // don't care
            4'b01_11: f = 1;     // mandatory 1
            4'b01_10: f = 0;     // mandatory 0
            
            // Row 11 (x[3]x[4] = 11)
            4'b11_00: f = 1;     // mandatory 1
            4'b11_01: f = 1;     // mandatory 1
            4'b11_11: f = 1'bx;  // don't care
            4'b11_10: f = 1'bx;  // don't care
            
            // Row 10 (x[3]x[4] = 10)
            4'b10_00: f = 1;     // mandatory 1
            4'b10_01: f = 1;     // mandatory 1
            4'b10_11: f = 0;     // mandatory 0
            4'b10_10: f = 1'bx;  // don't care
            
            default: f = 1'bx;    // catch-all (shouldn't occur)
        endcase
    end
endmodule