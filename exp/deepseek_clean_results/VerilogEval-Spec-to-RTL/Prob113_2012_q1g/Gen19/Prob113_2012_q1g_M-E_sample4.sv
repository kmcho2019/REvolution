module TopModule(
    input [3:0] x,
    output f
);
    // Implement as a 16x1 ROM
    reg out;
    
    always @(*) begin
        case(x)
            4'b0000: out = 1'b1;  // x3x2=00, x1x0=00
            4'b0001: out = 1'b0;  // x3x2=00, x1x0=01
            4'b0010: out = 1'b1;  // x3x2=00, x1x0=10
            4'b0011: out = 1'b0;  // x3x2=00, x1x0=11
            
            4'b0100: out = 1'b0;  // x3x2=01, x1x0=00
            4'b0101: out = 1'b0;  // x3x2=01, x1x0=01
            4'b0110: out = 1'b0;  // x3x2=01, x1x0=10
            4'b0111: out = 1'b0;  // x3x2=01, x1x0=11
            
            4'b1000: out = 1'b1;  // x3x2=10, x1x0=00
            4'b1001: out = 1'b1;  // x3x2=10, x1x0=01
            4'b1010: out = 1'b1;  // x3x2=10, x1x0=10
            4'b1011: out = 1'b0;  // x3x2=10, x1x0=11
            
            4'b1100: out = 1'b1;  // x3x2=11, x1x0=00
            4'b1101: out = 1'b1;  // x3x2=11, x1x0=01
            4'b1110: out = 1'b0;  // x3x2=11, x1x0=10
            4'b1111: out = 1'b1;  // x3x2=11, x1x0=11
            
            default: out = 1'b0;
        endcase
    end
    
    assign f = out;
endmodule